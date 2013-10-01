module NicoMedia
  class Report
    class Fail
      def self.execute e
        NicoMedia::Report::Log.write("exception", "#{e.message} / #{e.backtrace}", "fail")
        NicoMedia::Report::Twitter.new.send_dm e.message
      end
    end
  end
end
