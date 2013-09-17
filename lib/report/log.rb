require 'logger'

class Report
  class Log
    ROOT = Setting.new.report["log"]["save"]

    def self.write(file, msg, option_dir = nil)
      NicoSystem::Directory.create "#{Log::ROOT}/#{option_dir}/"
      Logger.new("#{Log::ROOT}/#{option_dir}/#{file}.log", 'weekly').debug msg
    end
  end
end
