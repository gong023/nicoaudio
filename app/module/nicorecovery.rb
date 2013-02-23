require "/var/www/scripts/nicoaudio/app/nicobase.rb"
require "optparse"

class NicoRecovery < NicoBase
  include NicoQuery
  ENABLE  = 0
  DISABLE = 1

  def initialize
    @mysql = initMysql

    parser = OptionParser.new
    @opt = {}
    begin
      parser.on('--from_date [YYYY-mm-dd]'){|v| @opt[:from_date] = v}
      parser.on('--to_date [YYYY-mm-dd]'){|v| @opt[:to_date] = v}
      parser.on('-e', '--checkExists [boolean]', TrueClass){|v| @opt['checkExists'] = v}
      parser.on('-n', '--checkNotExists [boolean]', TrueClass){|v| @opt['checkNotExists'] = v}
      parser.on('-r', '--reDownload [boolean]', TrueClass){|v| @opt['reDownload'] = v}
      parser.parse!(ARGV)
    rescue OptionParser::MissingArgument
      pp 'arg error'
      exit!
    end
    @opt[:to_date] = Time.now.strftime("%Y-%m-%d %H:%M:%S") if @opt[:to_date].nil?
    @opt[:from_date] = ((Date.today) - 1).to_s if @opt[:from_date].nil?
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
      next if row['state'] == 0
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

NicoRecovery.new.execute
pp 'ok'
