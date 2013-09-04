class Report
  class Fail
    def self.execute e
      # Log e.backtrace
      Report::Twitt.new.send_dm e.message
    end
  end
end
