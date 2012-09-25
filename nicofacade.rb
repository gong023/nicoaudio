#!/usr/local/bin/ruby

require "#{Dir::pwd}/class/nicoranking.rb"
require "#{Dir::pwd}/class/nicotweet.rb"

exit() unless $*[0] == '--type'
exit() unless $*[2] == '--category'
type = $*[1]
category = $*[3]
twitter = NicoTweet.new
logger = Logger.new("./log/#{type}/benchmark.log", 'weekly')
nico = NicoRanking.new(category)
benchmark =  Benchmark::measure {
  begin
    type == 'get' ? nico.get : nico.set
  rescue
    logger.debug("FAILED!!! #{type} / #{category}")
    twitter.sendDM("FAILED!!! /type:#{type}/category:#{category}/#{Date::today.to_s}")
    exit
  end
}
twitter.sendDM("finished /type:#{type}/category:#{category}/#{benchmark}/#{Date::today.to_s}")
logger.debug("#{type} / #{category} /#{benchmark}")
pp 'ok'
