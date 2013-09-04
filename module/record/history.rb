class Record

  class History
    TABLE = "history"
    STATE_UNDOWNLOADED = 0
    STATE_DOWNLOADED = 1
    attr_writer :video_id, :title, :state, :created_at, :updated_at

    def initialize
      @parent = Record.new
    end

    def create_table
    end

    def create param
      colums = param.keys.inject("") {|m, k| m + "#{k.to_s},"}.gsub!(/,$/, "")
      values = param.values.inject("") {|m, k| m + "'#{@parent.mysql.escape(k.to_s)}',"}.gsub!(/,$/, "")
      @parent.execute("INSERT IGNORE INTO #{TABLE} (#{colums}) VALUES (#{values})")
    end

    def read where = ""
      @parent.execute("SELECT * from #{TABLE} " + where)
    end

    def update(colum, value, where = nil)
      @parent.execute("UPDATE #{TABLE} SET #{colum}=#{value} " + where)
    end

    def update_state_dowloaded ids
      ids.each {|id| update("state", STATE_DOWNLOADED, "WHERE video_id='#{id}'")}
    end
  end

end
