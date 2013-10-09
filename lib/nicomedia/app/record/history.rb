module NicoMedia
  class Record
    class History
      TABLE = "history"
      STATE_UNDOWNLOAD = 0
      STATE_DOWNLOADED = 1
      STATE_CONVERT = 2
      STATE_UPLOAD = 3

      def initialize
        @parent = Record.new
      end

      def create param
        colums = param.keys.inject("") {|m, k| m + "#{k.to_s},"}.gsub!(/,$/, "")
        values = param.values.inject("") {|m, k| m + "'#{@parent.mysql.escape(k.to_s)}',"}.gsub!(/,$/, "")
        @parent.execute("INSERT IGNORE INTO #{TABLE} (#{colums}) VALUES (#{values})")
      end

      def create_new(list, idx = 0)
        return if list.count == idx + 1
        create({ video_id: list[idx].keys[0], title: list[idx].values[0], state: STATE_UNDOWNLOAD })
        create_new(list, idx + 1)
      end

      def read where = ""
        @parent.execute("SELECT * from #{TABLE} " + where)
      end

      def read_recently state
        state = Record::History.const_get("STATE_#{state.upcase}")
        sch = Schedule::Ranking.recently
        read "WHERE state = #{state} AND created_at between '#{sch[:from]}' AND '#{sch[:to]}'"
      end

      def read_created_at video_id
        l = read("WHERE video_id = '#{video_id.scan(/^.{2}\d+/)[0]}'").to_a.pop
        Schedule::Util.parse_to_Ymd(l["created_at"])
      end

      def update(colum, value, where = nil)
        @parent.execute("UPDATE #{TABLE} SET #{colum}=#{value} " + where)
      end

      def update_state(ids, state)
        state = History.const_get("STATE_#{state.upcase}")
        ids.each {|id| update("state", state, "WHERE video_id='#{id}'")}
      end

    end
  end
end
