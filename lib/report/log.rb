require 'logger'
module NicoMedia
  class Report
    class Log
      ROOT = NicoMedia::Setting.new.report["log"]["save"]

      def self.write(file, msg, option_dir = nil)
        NicoMedia::System::Directory.create "#{Log::ROOT}/#{option_dir}/"
        Logger.new("#{Log::ROOT}/#{option_dir}/#{file}.log", 'weekly').debug msg
      end
    end
  end
end
