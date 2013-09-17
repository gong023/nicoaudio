class Report
  class Fail
    def self.execute e
      Report::Log.write("exception", "#{e.message} / #{e.backtrace}", "fail")
      Report::Twitt.new.send_dm e.message
    end
  end
end
