module NicoMedia
  class App
    class Dump
      def initialize
        @report_count = 0
        @ended_ids = Time.now.to_s
      end

      def all_by_rand
        while true
          begin
            target = record_history.read("where state=0 order by rand() limit 1").to_a
            break if target.count == 0
            record_history.within_shared_lock(target[0]["id"], target[0]["video_id"], &method(:single))
            report_interval target[0]["video_id"]
          rescue => e
            Report::Abnormal.execute e
            next # nice-catch
          end
        end
      end

      def single video_id
        Agent::Video.exec video_id
        record_history.update_state(video_id, :downloaded) if System::File.exist?("video", video_id)
        System::Ffmpeg.exec(video_id)
        record_history.update_state(video_id, :converted) if System::File.exist?("audio", video_id)
        System::S3.exec video_id
        if System::S3.exist?("#{video_id}.mp3")
          record_history.update_state(video_id, :uploaded)
          path_date = record_history.read_created_at video_id
          System::File.destroy("#{System::VIDEO_ROOT}/#{path_date}", "#{video_id}.mp4")
        end
      end

      private
      def record_history
        @record_history ||= Record::History.instance
      end

      def report_interval video_id
        Report::Log.write("dump", video_id)
        if @report_count % 10 == 1
          Report::Twitter.new.send_dm @ended_ids
          @ended_ids = Time.now.to_s
        else
          @ended_ids = "#{@ended_ids} / #{video_id}"
        end
        @report_count += 1
      end
    end
  end
end
