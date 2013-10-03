require "mysql2"

module NicoMedia
  class Record
    attr_reader :mysql

    def initialize
      setting = Setting.new.mysql
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

  require_relative "./record/history"
end
