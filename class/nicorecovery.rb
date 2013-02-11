require "/var/www/scripts/nicoaudio/class/nicobase.rb"
require "optparse"

class NicoRecovery < NicoBase
  include NicoQuery

  def initialize
    @mysql = initMysql
  end

  def execute
    parser = OptionParser.new
    opt = {}
    begin
      parser.on('--from_date [VALUE]') do |v|
        opt[:from_date] = v.nil? ? Time.now.strftime("%Y-%m-%d %H:%M:%S") : v
      end
      parser.on('--to_date [VALUE]') do |v|
        opt[:to_date] = v.nil? ? ((Date.today) - 1).to_s : v
      end
      parser.parse!(ARGV)
    rescue OptionParser::MissingArgument
      pp 'arg error'
      exit!
    end
    findNotFound(opt[:from_date], opt[:to_date])
  end

  def findNotFound from_date, to_date
    select = find_by_interval(from_date, to_date)
    @mysql.query(select).each do |row|
      dir_date = row['ctime'].to_s.match(/^[0-9]{4}?-[0-9]{2}?-[0-9]{2}/).to_s
      check_file = "#{HTTP_ROOT}public/audio/all/#{dir_date}/#{row['video_id']}.mp3"
      if ! FileTest.exist? check_file
        pp row['video_id']
        @mysql.query(update_video_state(1, row['video_id']));
      end
    end
  end

  def downloadByVideoId video_id
    #TODO
  end
end

NicoRecovery.new.execute
pp 'ok'
