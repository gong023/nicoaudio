module NicoMedia
  class Report
    class Abnormal
      def self.execute e
        Log.write("exception", "#{e.message} / #{e.backtrace}", "fail")
        Twitter.new.send_dm e.message if SETTING["twitter"]["skip"] == false
      end
    end
  end
end
