require "sqlite3"
require "singleton"
require_relative "questions_db"

class DatabaseAccessor
  def initialize
  end
  
  def save
    argvars = self.instance_variables
    raise "already saved" unless @id.nil?
    argvars.delete(:@id)
    argvars.delete(:@database)
    values = argvars.map { |arg| self.send(arg.to_s[1..-1]) }
    columns_string = argvars.map { |x| x.to_s[1..-1]}.join(", ")
    values_string = values.map { |value| "?"}.join(", ")
    
    QuestionsDatabase.instance.execute(<<-SQL, values)
    INSERT INTO
      #{@database} (#{ columns_string })
    VALUES
      (#{values_string})
    SQL
    
    @id = QuestionsDatabase.instance.last_insert_row_id
  end
end
