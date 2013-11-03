module NicoMedia
  class Agent
    class Video
      def self.exec video_id
        System::File.create_mp4(video_id) { Agent.client.video(video_id).get_video }
      rescue Net::HTTPClientError
        Record::History.instance.update_state(video_id, :invalid)
        Log.write("video", "#{video_id} / client error", "fail")
      rescue Net::HTTPServerError
        Record::History.instance.update_state(video_id, :invalid)
        Log.write("video", "#{video_id} / server error", "fail")
      end
    end
  end
end
