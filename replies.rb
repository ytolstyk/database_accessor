require "sqlite3"
require "singleton"
require_relative "questions_db"
# class names should be singular
# parameterize query variables
class Reply
  
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
    Reply.new(result)
  end
  
  attr_accessor :id, :body, :question_id, :parent_id, :reply_author_id
  
  def initialize(options = {})
    @id = options['id']
    @body = options["body"]
    @question_id = options["question_id"]
    @parent_id = options["parent_id"]
    @reply_author_id = options["reply_author_id"]
  end

end