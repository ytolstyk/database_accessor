require "sqlite3"
require "singleton"
require_relative "questions_db"

class Question
  
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
    Question.new(result)
  end
  
  attr_accessor :id, :title, :body, :author_id
  
  def initialize(options = {})
    @id = options['id']
    @title = options["title"]
    @body = options["body"]
    @author_id = options["author_id"]
  end
  
end