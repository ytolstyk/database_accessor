require "sqlite3"
require "singleton"
require_relative "questions_db"
require_relative "questions_followers"
require_relative "question_likes"
require_relative "database_accessor"

class Question < DatabaseAccessor
  
  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM questions')
    results.map { |result| Question.new(result) }
  end
  
  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
     questions
    WHERE
      id = ?
    SQL
    Question.new(result.first)
  end
  
  def self.find_by_author(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
     questions
    WHERE
      author_id = ?
    SQL
    results.map { |result| Question.new(result) }
  end
  
  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end
  
  attr_accessor :id, :title, :body, :author_id
  
  def initialize(options = {})
    @id = options['id']
    @title = options["title"]
    @body = options["body"]
    @author_id = options["author_id"]
    @database = "questions"
  end
  
  # moved to super
  # def save
 #    raise "already saved" unless @id.nil?
 #
 #    QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @author_id)
 #    INSERT INTO
 #      questions (title, body, author_id)
 #    VALUES
 #      (?, ?, ?)
 #    SQL
 #
 #    @id = QuestionsDatabase.instance.last_insert_row_id
 #  end
  
  def likers
    QuestionLike.likers_for_question_id(@id)
  end
  
  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end
  
  def followers
    QuestionFollower.followers_for_question_id(@id)
  end
  
  def replies
    Reply.find_by_question(@id)
  end
  
  def author
    User.find_by_id(@author_id)
  end  
end

if $PROGRAM_NAME == __FILE__
  questions = Question.all
  puts questions[0].followers
  puts questions[0].num_likes
  puts questions[0].likers.map { |x| x.name }
end