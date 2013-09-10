require 'benchmark'

class Report
  class Success

    def self.execute
      ->(fetch_music, to_record, download_recently, to_mp3) do
#        to_record.call(fetch_music.call)
#        bench_download = Benchmark::measure { download_recently.call }
#        bench_tomp3 = Benchmark::measure { to_mp3.call }
#
#        Report::Twitt.new.send_dm bench_download + bench_tomp3
      end.curry
    end
  end
end
