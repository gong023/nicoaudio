require 'benchmark'

class Report
  class Success

    def self.execute
      ->(fetch_music, to_record, download_recently, to_mp3) do
        Benchmark.bm do |b|
          b.report("Ranking / fetch and to history") { to_record.call(fetch_music.call) }
          b.report("Video / download") { download_recently.call }
          b.report("Video / to mp3") { to_mp3.call }
        end
      end.curry
    end
  end
end
