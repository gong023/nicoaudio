require "/var/www/scripts/nicoaudio/class/nicobase.rb"
require "optparse"

class NicoRecovery < NicoBase
  include NicoQuery

  def initialize
    @mysql = initMysql
    @nico = initNico
    @nico.login
  end

  def execute
    parser = OptionParser.new
    opt = {}
    begin
      parser.on('--from_date [YYYY-mm-dd]'){|v| opt[:from_date] = v}
      parser.on('--to_date [YYYY-mm-dd]'){|v| opt[:to_date] = v}
      parser.parse!(ARGV)
    rescue OptionParser::MissingArgument
      pp 'arg error'
      exit!
    end
    opt[:to_date] = Time.now.strftime("%Y-%m-%d %H:%M:%S") if opt[:to_date].nil?
    opt[:from_date] = ((Date.today) - 1).to_s if opt[:from_date].nil?

    findNotFound(opt[:from_date], opt[:to_date])
    reDownload(opt[:from_date], opt[:to_date])
  end

  def findNotFound from_date, to_date
    select = find_by_interval(from_date, to_date)
    @mysql.query(select).each do |row|
      dir_date = row['ctime'].to_s.match(/^[0-9]{4}?-[0-9]{2}?-[0-9]{2}/).to_s
      check_file = "#{HTTP_ROOT}public/audio/all/#{dir_date}/#{row['video_id']}.mp3"
      if ! FileTest.exist? check_file
        pp row['video_id']
        @mysql.query(update_video_state(1, row['video_id']))
      elsif
        @mysql.query(update_video_state(0, row['video_id']))
      end
    end
  end

  def reDownload from_date, to_date
    select = find_by_interval(from_date, to_date)
    @mysql.query(select).each do |row|
      next if row['state'] == 0

      dir_date = row['ctime'].to_s.match(/^[0-9]{4}?-[0-9]{2}?-[0-9]{2}/).to_s
      FileUtils.mkdir_p("./video/recover/#{dir_date}")
      begin
        agent = @nico.video("#{row["video_id"]}")
        agent.get
        file_name = "./video/recover/#{dir_date}/#{row["video_id"]}.mp4"
        open(file_name, "w"){|f| f.write(agent.get_video)}
      rescue
        pp $@
      end
    end
  end
end

NicoRecovery.new.execute
pp 'ok'
