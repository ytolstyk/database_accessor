require "sqlite3"
require "singleton"
require_relative "questions_db"
require_relative "questions"
require_relative "users"
require_relative "database_accessor"

class QuestionLike < DatabaseAccessor
  
  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM question_likes')
    results.map { |result| QuestionLike.new(result) }
  end
  
  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      question_likes
    WHERE
      id = ?
    SQL
        
    QuestionLike.new(result.first)
  end
  
  def self.likers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      users.*
    FROM
      users
    JOIN
      question_likes
    ON users.id = question_likes.liker_id
    WHERE
      question_likes.liked_question_id = ?
    SQL
    
    results = results.map { |result| User.new(result) }
  end
  
  def self.num_likes_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      COUNT(users.id) likes
    FROM
      users
    JOIN
      question_likes
    ON users.id = question_likes.liker_id
    WHERE
      question_likes.liked_question_id = ?
    SQL
    
    results.first["likes"]
  end
  
  def self.liked_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      questions.*
    FROM
      questions
    JOIN
      question_likes
    ON questions.id = question_likes.liked_question_id
    WHERE
      question_likes.liker_id = ?
    SQL
    
    results = results.map { |result| Question.new(result) }
  end
  
  def self.most_liked_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
      questions.*, COUNT(question_likes.liker_id)
    FROM
      questions
    JOIN
      question_likes
    ON
      questions.id = question_likes.liked_question_id
    GROUP BY
      question_likes.liked_question_id
    ORDER BY
      COUNT(question_likes.liker_id) DESC
    LIMIT
      ?
    SQL
    
    results = results.map { |result| Question.new(result) }
  end
  
  attr_accessor :id, :liker_id, :liked_question_id
  
  def initialize(options = {})
    @id = options['id']
    @liker_id = options["liker_id"]
    @liked_question_id = options["liked_question_id"]
  end
end

if $PROGRAM_NAME == __FILE__
  puts QuestionLike.most_liked_questions(1).map { |q| q.title }
end
