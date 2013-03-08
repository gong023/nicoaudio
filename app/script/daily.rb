require "/var/www/scripts/nicoaudio/app/nicobase.rb"
require "optparse"
require 'logger'
require 'benchmark'

def ParseOpt
    opt = OptionParser.new
    ret = {}
    opt.on("--type 'set' or 'get'"){|v| ret[:type] = v}
    opt.on("--category 'all' or 'music'"){|v| ret[:category] = v}
    ret[:tweet_skip] = false
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

def getEnv
  IO.readlines('/etc/my/sinatra/nicoplay/env.txt')[0].chomp!
end

args = ParseOpt()
env  = getEnv()
twitt  = NicoBase.new.tweet(args[:tweet_skip])
nico   = NicoBase.new.ranking(args[:category])
logger = Logger.new("./log/#{args[:type]}/benchmark.log", 'weekly')
bench  = Benchmark::measure {
  begin
    args[:type] == 'get' ? nico.get(args[:duration]) : nico.set
  rescue => e
    pp e
    logger.debug("FAILED!!! #{args[:type]} / #{args[:category]} / #{e}")
    twitt.sendDM("FAILED!!! /type:#{args[:type]}/category:#{args[:category]}/#{Date::today.to_s}/#{e}")
    exit!
  end
}
twitt.sendDM("finished #{env}/type:#{args[:type]}/category:#{args[:category]}/#{bench}/#{Date::today.to_s}")
logger.debug("#{args[:type]} / #{args[:category]} /#{bench}")
pp 'ok'
