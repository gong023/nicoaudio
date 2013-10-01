require 'benchmark'
module NicoMedia
  class Report
    class Success
      def self.execute
        ->(download_recently, to_mp3) do
          bench_download = Benchmark::measure { download_recently.call }.to_a.pop
          NicoMedia::Report::Log.write("video", bench_download, "success")
          bench_tomp3 = Benchmark::measure { to_mp3.call }.to_a.pop
          NicoMedia::Report::Log.write("audio", bench_tomp3, "success")

          NicoMedia::Report::Twitter.new.send_dm bench_download + bench_tomp3
        end.curry
      end
    end
  end
end
