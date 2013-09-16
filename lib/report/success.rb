require 'benchmark'

class Report
  class Success

    def self.execute
      ->(download_recently, to_mp3) do
        bench_download = Benchmark::measure { download_recently.call }
        bench_tomp3 = Benchmark::measure { to_mp3.call }

        Report::Twitt.new.send_dm bench_download + bench_tomp3
      end.curry
    end
  end
end
