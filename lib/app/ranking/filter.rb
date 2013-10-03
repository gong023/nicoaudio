module NicoMedia
  class App
    class Ranking
      class Filter
        def self.detect(ranks, regrep, abort_regrep)
          ranks.inject([]) do |result, r|
            result << {r.id => r.title} if r.title =~ regrep && r.title !~ abort_regrep
            result
          end
        end
        require_relative "./filter/music"
      end
    end
  end
end
