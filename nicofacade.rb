require "/var/www/scripts/nicoaudio/class/nicobase.rb"
require "#{SCRIPT_ROOT}/class/nicoranking.rb"
require "#{SCRIPT_ROOT}/class/nicotweet.rb"
require "optparse"

def ParseOpt
  opt = OptionParser.new
  ret = {}
  begin
    opt.on("--type 'set' or 'get'") {|v| pp v;ret[:type] = v}
    opt.on("--category 'all' or 'music'") {|v| ret[:category] = v}
    ret[:duration] = nil
    opt.on('--duration [YYYY-mm-dd~YYYY-mm-dd]')  do |v|
      ret[:duration] = v if v =~ /^[0-9]{4}?-[0-9]{2}?-[0-9]{2}?~[0-9]{4}?-[0-9]{2}?-[0-9]{2}?/
    end 
    opt.parse!(ARGV)
    return ret
  rescue OptionParser::MissingArgument
    pp 'arg error'
    exit!
  end
end

args = ParseOpt()
f = open('/etc/my/sinatra/nicoplay/env.txt')
env = f.read
f.close
twitter = NicoTweet.new
logger = Logger.new("./log/#{args[:type]}/benchmark.log", 'weekly')
nico = NicoRanking.new args[:category]
benchmark =  Benchmark::measure {
  begin
    args[:type] == 'get' ? nico.get(args[:duration]) : nico.set
  rescue => e
    pp e
    logger.debug("FAILED!!! #{args[:type]} / #{args[:category]} / #{e}")
    twitter.sendDM("FAILED!!! /type:#{args[:type]}/category:#{args[:category]}/#{Date::today.to_s}")
    exit!
  end
}
twitter.sendDM("finished #{env}/type:#{args[:type]}/category:#{args[:category]}/#{benchmark}/#{Date::today.to_s}")
logger.debug("#{args[:type]} / #{args[:category]} /#{benchmark}")
pp 'ok'
