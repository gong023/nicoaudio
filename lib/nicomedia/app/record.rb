require "mysql2"

module NicoMedia
  class Record
    autoload :History, "record/history"
    attr_reader :mysql
    SETTING = Setting.mysql

    def initialize
      @mysql = Mysql2::Client.new(
          host:     SETTING["host"],
          username: SETTING["user"],
          password: SETTING["password"],
          database: SETTING["database"]
      )
    end

    def execute query
      @mysql.query(query)
    end
  end
end
