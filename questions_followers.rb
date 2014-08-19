require "sqlite3"
require "singleton"
require_relative "questions_db"

class QuestionFollower
  
  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM question_followers')
    results.map { |result| QuestionFollower.new(result) }
  end
  
  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      question_followers
    WHERE
      id = ?
    SQL
    QuestionFollower.new(result)
  end
  
  attr_accessor :id, :follower_id, :question_id
  
  def initialize(options = {})
    @id = options['id']
    @follower_id = options["follower_id"]
    @question_id = options["question_id"]
  end
  
end