require "sqlite3"
require "singleton"
require_relative "questions_db"
require_relative "questions"
require_relative "users"
require_relative "database_accessor"

class Reply < DatabaseAccessor
  
  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM replies')
    results.map { |result| Reply.new(result) }
  end
  
  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      replies
    WHERE
      id = ?
    SQL
    Reply.new(result.first)
  end
  
  def self.find_by_user_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      replies
    WHERE
      author_id = ?
    SQL
    results.map { |result| Reply.new(result) }
  end
  
  def self.find_by_question(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      replies
    WHERE
      question_id = ?
    SQL
    results.map { |result| Reply.new(result) }
  end
  
  attr_accessor :id, :body, :question_id, :parent_id, :reply_author_id
  
  def initialize(options = {})
    @id = options['id']
    @body = options["body"]
    @question_id = options["question_id"]
    @parent_id = options["parent_id"]
    @reply_author_id = options["reply_author_id"]
    @database = "replies"
  end
  
  # moved to super
  # def save
#     raise "already saved, son" unless @id.nil?
#
#     argvars = [@body, @question_id, @parent_id, @reply_author_id]
#     QuestionsDatabase.instance.execute(<<-SQL, *argvars)
#     INSERT INTO
#       replies (body, question_id, parent_id, reply_author_id)
#     VALUES
#       (?, ?, ?, ?)
#     SQL
#
#     @id = QuestionsDatabase.instance.last_insert_row_id
#   end
  
  def author
    User.find_by_id(@reply_author_id)
  end
  
  def question
    Question.find_by_id(@question_id)
  end
  
  def parent_reply
    Reply.find_by_id(@parent_id)
  end
  
  def child_replies
    results = QuestionsDatabase.instance.execute(<<-SQL, @id)
    SELECT
      *
    FROM
      replies
    WHERE
      parent_id = ?
    SQL
    results.map { |result| Reply.new(result) }
  end

end