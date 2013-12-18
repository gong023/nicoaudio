require 'benchmark'
module NicoMedia
  class Report
    class Normal
      def self.hourly
        ->(download_mp4, convert_to_mp3, upload_to_s3) do
          bench_download = Benchmark::measure { download_mp4.call }.to_a.pop
          Log.write("video", bench_download, "success")
          bench_tomp3 = Benchmark::measure { convert_to_mp3.call }.to_a.pop
          Log.write("music", bench_tomp3, "success")
          bench_tos3 = Benchmark::measure { upload_to_s3.call }.to_a.pop
          Log.write("s3", bench_tos3, "success")

          msg = "mp4:#{bench_download} / mp3:#{bench_tomp3} / s3:#{bench_tos3}"
          SETTING["dry"] ? pp(msg) : Twitter.new.send_dm(msg)
        end.curry
      end
    end
  end
end
