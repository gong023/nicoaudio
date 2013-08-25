class Record

  class History
    TABLE = "history"
    attr_writer :video_id, :title, :state, :created_at, :updated_at

    def initialize
      @parent = Record.new
    end

    def create_table
    end

    def create param
      colums = param.keys.inject("") {|m, k| m + "#{k.to_s},"}.gsub!(/,$/, "")
      values = param.values.inject("") {|m, k| m + "'#{k.to_s}',"}.gsub!(/,$/, "")
      @parent.execute("INSERT IGNORE INTO #{TABLE} (#{colums}) VALUES (#{values})")
    end

    def read where = ""
      @parent.execute("SELECT * from #{TABLE} " + where)
    end

    def update
    end
  end

end
