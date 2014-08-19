require "sqlite3"
require "singleton"
require_relative "question_db"

class QuestionLike
  
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
  
  attr_accessor :id, :liker_id, :liked_question_id
  
  def initialize(options = {})
    @id = options['id']
    @liker_id = options["liker_id"]
    @liked_question_id = options["liked_question_id"]
  end
end