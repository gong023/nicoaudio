module NicoMedia
  class Agent
    class Ranking
      class Filter
        def self.squeeze(ranks, regrep, abort_regrep)
          ranks.inject([]) do |result, r|
            result << {r.id => r.title} if r.title =~ regrep && r.title !~ abort_regrep
            result
          end
        end
      end
      require_relative "./filter/music"
    end
  end
end
