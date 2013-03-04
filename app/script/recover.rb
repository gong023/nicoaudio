require "/var//www/scripts/nicoaudio/app/nicobase.rb"
require "optparse"

def ParseOpt
    parser = OptionParser.new
    opt = {}
    parser.on('--from_date [YYYY-mm-dd]'){|v| opt[:from_date] = v}
    parser.on('--to_date [YYYY-mm-dd]'){|v| opt[:to_date] = v}
    parser.on('-e', '--checkExists [boolean]', TrueClass){|v| opt['checkExists'] = v}
    parser.on('-n', '--checkNotExists [boolean]', TrueClass){|v| opt['checkNotExists'] = v}
    parser.on('-r', '--reDownload [boolean]', TrueClass){|v| opt['reDownload'] = v}
    parser.parse(ARGV)
    opt[:to_date] = Time.now.strftime("%Y-%m-%d %H:%M:%S") if opt[:to_date].nil?
    opt[:from_date] = ((Date.today) - 1).to_s if opt[:from_date].nil?
    opt
  rescue OptionParser::MissingArgument
    pp 'arg error'
    exit!
end

opt = ParseOpt()
recover_obj = NicoBase.new.recover(opt)
recover_obj.execute
