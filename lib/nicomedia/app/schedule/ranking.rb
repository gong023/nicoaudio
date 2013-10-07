module NicoMedia
  class Schedule
    class Ranking
      def self.recently
        {
          :from => Util.parse_to_YmdHis(Chronic.parse("24 hours ago")),
          :to   => Util.parse_to_YmdHis(Chronic.parse("now"))
        }
      end
    end
  end
end
