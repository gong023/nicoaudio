require "mysql2"

class Record < Base

  def initialize
    setting = Base.load_setting["mysql"]
    @mysql = Mysql2::Client.new(
      :host     => setting["host"],
      :username => setting["user"],
      :password => setting["password"],
      :database => setting["database"]
    )
  end

  def execute query
    @mysql.query(query)
  end

end

require_relative "./record/history.rb"
