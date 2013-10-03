module NicoMedia
  class App
    require_relative "./ranking/filter"

    class Ranking
    @nico = App.instance

    URL = ["", "g_ent2"] # category url(general, music)

    class << self
      def reload
        @nico.login
        ranks = URL.inject([]) { |ranks, category| @nico.agent.ranking(category) }
        to_record Filter_Music.detect(ranks)
      end

      def recently_from_record state
        schedule = Schedule::Ranking.recently
        w = "WHERE state = #{state} AND created_at between '#{schedule[:from]}' AND '#{schedule[:to]}'"
        @nico.record_history.read(w)
      end

      private
      def to_record(rank, idx = 0)
        return if rank.count == idx + 1
        p = { video_id: rank[idx].keys[0], title: rank[idx].values[0], state: Record::History::STATE_UNDOWNLOADED }
        @nico.record_history.create(p)
        to_record(rank, idx + 1)
      end
    end
    end
  end
end
