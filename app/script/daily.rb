require "/var/www/scripts/nicoaudio/app/nicobase.rb"
require "optparse"

def ParseOpt
    opt = OptionParser.new
    ret = {}
    opt.on("--type 'set' or 'get'"){|v| ret[:type] = v}
    opt.on("--category 'all' or 'music'"){|v| ret[:category] = v}
    ret[:tweet_skip] = true
    opt.on("--tweet_skip [boolean]", TrueClass){|v| ret[:tweet_skip] = v}
    ret[:duration] = nil
    opt.on('--duration [YYYY-mm-dd~YYYY-mm-dd]') do |v|
      ret[:duration] = v if v =~ /^[0-9]{4}?-[0-9]{2}?-[0-9]{2}?~[0-9]{4}?-[0-9]{2}?-[0-9]{2}?/
    end 
    opt.parse(ARGV)
    return ret
  rescue OptionParser::MissingArgument
    pp 'arg error'
    exit!
end

args = ParseOpt()
f = open('/etc/my/sinatra/nicoplay/env.txt')
env = f.read
f.close
base = NicoBase.new
twitter = base.tweet(args[:tweet_skip])
logger = Logger.new("./log/#{args[:type]}/benchmark.log", 'weekly')
nico = base.ranking args[:category]
benchmark =  Benchmark::measure {
  begin
    args[:type] == 'get' ? nico.get(args[:duration]) : nico.set
  rescue => e
    pp e
    logger.debug("FAILED!!! #{args[:type]} / #{args[:category]} / #{e}")
    twitter.sendDM("FAILED!!! /type:#{args[:type]}/category:#{args[:category]}/#{Date::today.to_s}/#{e}")
    exit!
  end
}
twitter.sendDM("finished #{env}/type:#{args[:type]}/category:#{args[:category]}/#{benchmark}/#{Date::today.to_s}")
logger.debug("#{args[:type]} / #{args[:category]} /#{benchmark}")
pp 'ok'
