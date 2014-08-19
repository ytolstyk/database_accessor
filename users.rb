require "sqlite3"
require "singleton"
require_relative "questions_db"
require_relative "questions"
require_relative "replies"
require_relative "questions_followers"
require_relative "question_likes"

class User
  
  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM users')
    results.map { |result| User.new(result) }
  end
  
  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      users
    WHERE
      id = ?
    SQL
    User.new(result.first)
  end
  
  def self.find_by_name(fname, lname)
    result = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
    SELECT
      *
    FROM
      users
    WHERE
      fname = ? AND lname = ?
    SQL
    
    User.new(result.first)
  end
  
  attr_accessor :id, :fname, :lname
  
  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']    
  end
  
  def save
    raise 'already saved!' unless @id.nil?
    
    QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
    INSERT INTO
      users (fname, lname)
    VALUES
      (?, ?)
    SQL
    
    @id = QuestionsDatabase.instance.last_insert_row_id
  end
  
  def name
    "#{fname} #{lname}"
  end
  
  def average_karma
    result = QuestionsDatabase.instance.execute(<<-SQL, @id)
    SELECT
      COUNT(question_likes.liker_id) / CAST(COUNT(DISTINCT (questions.id)) AS FLOAT) x
    FROM
      questions
    LEFT OUTER JOIN
      question_likes
    ON questions.id = question_likes.liked_question_id
    WHERE
      questions.author_id = ?
    GROUP BY
      questions.id
    SQL

    return result.first['x'] unless result.empty? 
    0
  end
  
  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end
  
  def authored_questions
    Question.find_by_author(@id)
  end
  
  def authored_replies
    Reply.find_by_user_id(@id)
  end
  
  def followed_questions
    QuestionFollower.followed_questions_for_user_id(@id)
  end
end

if $PROGRAM_NAME == __FILE__
  users = User.all
  puts users[2].followed_questions
  puts users[0].liked_questions.map { |x| x.title }
  puts users[0].average_karma
end