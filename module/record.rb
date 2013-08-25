require "mysql2"

class Record < Base

  def initialize
    load_setting
    @mysql = Mysql2::Client.new(
      :host     => @setting["mysql"]["host"],
      :username => @setting["mysql"]["user"],
      :password => @setting["mysql"]["password"],
      :database => @setting["mysql"]["database"]
    )
  end

  def execute query
    @mysql.query(query)
  end

end

require_relative "./record/history.rb"
