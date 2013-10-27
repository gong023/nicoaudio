require 'logger'
module NicoMedia
  class Report
    class Log
      ROOT = Setting.report["log"]["save"]

      def self.write(file, msg, option_dir = nil)
        System::Directory.create "#{ROOT}/#{option_dir}/"
        Logger.new("#{ROOT}/#{option_dir}/#{file}.log", 'weekly').debug msg
      end
    end
  end
end
