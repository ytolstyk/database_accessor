require "sqlite3"
require "singleton"
require_relative "questions_db"
require_relative "users"
require_relative "questions"

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
    QuestionFollower.new(result.first)
  end
  
  def self.followers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      users.*
    FROM
      users
    JOIN
      question_followers
    ON users.id = question_followers.follower_id
    WHERE
      question_id = ?
    SQL
    
    results.map { |result| User.new(result) }
  end
  
  def self.followed_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      questions.*
    FROM
      questions
    JOIN
      question_followers
    ON questions.id = question_followers.question_id
    WHERE
      follower_id = ?
    SQL
    
    results.map { |result| Question.new(result) }
  end
  
  def self.most_followed_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
      questions.*, COUNT(follower_id)
    FROM
      questions
    JOIN
      question_followers
    ON questions.id = question_followers.question_id
    GROUP BY
      questions.id
    ORDER BY
      COUNT(follower_id) DESC
    LIMIT 
      ?
    SQL
    
    results.map { |result| Question.new(result) }
  end
  
  attr_accessor :id, :follower_id, :question_id
  
  def initialize(options = {})
    @id = options['id']
    @follower_id = options["follower_id"]
    @question_id = options["question_id"]
  end
  
end

if $PROGRAM_NAME == __FILE__
  puts QuestionFollower.followers_for_question_id(1).map { |user| user.name }
  puts QuestionFollower.followed_questions_for_user_id(2).map { |question| question.title }
  puts QuestionFollower.most_followed_questions(1)
end