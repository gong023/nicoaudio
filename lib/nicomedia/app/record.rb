require "mysql2"

module NicoMedia
  class Record
    attr_reader :mysql
    SETTING = Setting.new.mysql

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

  require "record/history"
end
