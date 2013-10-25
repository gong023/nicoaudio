module NicoMedia
  class Agent
    class Ranking
      autoload :Filter, "ranking/filter"

      URL = ["", "g_ent2"].freeze # category url(general, music)

      def self.all
        URL.inject([]) { |ranks, category| Agent.client.ranking(category) }
      end

      def self.filtered name
        Ranking.const_get("Filter_#{name.capitalize}").send(:squeeze, *[all])
      end
    end
  end
end
