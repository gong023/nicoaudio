#!/usr/local/bin/ruby

require "/var/www/scripts/nicoaudio/class/nicobase.rb"
require "#{SCRIPT_ROOT}/class/nicoranking.rb"
require "#{SCRIPT_ROOT}/class/nicotweet.rb"

exit() unless $*[0] == '--type'
exit() unless $*[2] == '--category'
type = $*[1]
category = $*[3]
duration = $*[5]
exit() if !duration.nil? && duration !~ /^[0-9]{4}?-[0-9]{2}?-[0-9]{2}?~[0-9]{4}?-[0-9]{2}?-[0-9]{2}?/
twitter = NicoTweet.new
logger = Logger.new("./log/#{type}/benchmark.log", 'weekly')
nico = NicoRanking.new category
benchmark =  Benchmark::measure {
  begin
    type == 'get' ? nico.get(duration) : nico.set
  rescue => e
    pp e
    logger.debug("FAILED!!! #{type} / #{category} / #{e}")
    twitter.sendDM("FAILED!!! /type:#{type}/category:#{category}/#{Date::today.to_s}")
    exit
  end
}
twitter.sendDM("finished /type:#{type}/category:#{category}/#{benchmark}/#{Date::today.to_s}")
logger.debug("#{type} / #{category} /#{benchmark}")
pp 'ok'
