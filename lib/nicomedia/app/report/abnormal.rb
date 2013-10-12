module NicoMedia
  class Report
    class Abnormal
      def self.execute e
        pp e.backtrace
        Log.write("exception", "#{e.message} / #{e.backtrace}", "fail")
        Twitter.new.send_dm e.message
      end
    end
  end
end
