module NicoMedia
  class Report
    class Fail
      def self.execute e
        Log.write("exception", "#{e.message} / #{e.backtrace}", "fail")
        Twitt.new.send_dm e.message
      end
    end
  end
end
