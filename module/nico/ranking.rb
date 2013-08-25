require_relative "./ranking/filter.rb"

class Nico

  class Ranking
    @nico = Nico.instance

    URL = ["", "g_ent2"] # category url(general, music)

    class << self
      def fetch_music
        @nico.login
        ranks = URL.inject([]) { |ranks, category| @nico.agent.ranking(category) }
        Filter::Music.execute(ranks)
      end

      def to_recoad(rank, idx = 0)
        return if rank.count == idx + 1
        p = {:video_id => rank[idx].keys[0], :title => rank[idx].values[0]} #need escape?
        @nico.record_history.create(p)
        to_recoad(rank, idx + 1)
      end

      def recently_from_record from_date = Chronic.parse("24 hours ago"), to_date = Chronic.parse("now")
        @nico.record_history.read("WHERE created_at between '#{from_date.to_s}' AND '#{to_date.to_s}'")
      end
    end
  end

end
