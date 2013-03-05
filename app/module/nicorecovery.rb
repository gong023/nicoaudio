class NicoBase
  def recover opt
    Recovery.new opt
  end

  class Recovery < NicoBase
    include NicoQuery
    ENABLE  = 0
    DISABLE = 1

    def initialize opt
      @mysql = initMysql
      @opt = opt
    end

    def execute
      @opt.each do |k, v|
        self.send(k) if v == true
      end
    end

    def checkExists
      takeList {|row, date|
        if FileTest.exist? date[:file]
          @mysql.query(update_video_state(ENABLE, row['video_id']))
        end
      }
    end

    def checkNotExists
      takeList {|row, date|
        if ! FileTest.exist? date[:file]
          @mysql.query(update_video_state(DISABLE, row['video_id']))
        end
      }
    end

    def reDownload
      @nico = initNico
      @nico.login
      takeList {|row, date|
        next if row['state'] == ENABLE
        FileUtils.mkdir_p("./video/recover/#{date[:dir]}")
        begin
          agent = @nico.video("#{row["video_id"]}")
          agent.get
          file_mp4 = "./video/recover/#{date[:dir]}/#{row["video_id"]}.mp4"
          open(file_mp4, "w"){|f| f.write(agent.get_video)}
        rescue
          pp $@
        end
      }
    end

    def takeList
      select = find_by_interval(@opt[:from_date], @opt[:to_date])
      @mysql.query(select).each do |row|
        date = getDealDate row
        yield(row, date)
      end
    end

    def getDealDate row
      d = row['ctime'].to_s.match(/^[0-9]{4}?-[0-9]{2}?-[0-9]{2}/).to_s
      f = "#{HTTP_ROOT}public/audio/all/#{d}/#{row['video_id']}.mp3"
      {:dir => d, :file => f}
    end

  end
end
