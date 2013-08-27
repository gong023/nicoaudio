class Schedule
  class Ranking

    def self.recently
      {
        :from => Chronic.parse("24 hours ago").to_s,
        :to   => Chronic.parse("now").to_s
      }
    end
  end
end
