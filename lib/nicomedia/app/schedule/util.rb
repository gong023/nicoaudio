module NicoMedia
  class Schedule
    class Util
      def self.today
        parse_to_Ymd Chronic.parse("today")
      end

      def self.parse_to_Ymd date
        date.to_s.match(/^\d{4}-\d{2}-\d{2}/)[0]
      end
    end
  end
end
