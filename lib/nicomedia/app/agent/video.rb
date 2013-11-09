module NicoMedia
  class Agent
    class Video
      def self.exec video_id
        System::File.create_mp4(video_id) { method(:byte).call(video_id) }
      rescue # TODO: Net::HTTPClientError, Net::HTTPServerError
        Record::History.instance.update_state(video_id, :invalid)
        Report::Log.write("video", "#{video_id} / error", "fail")
      end

      def self.byte video_id
        Agent.client.video(video_id).get_video
      end
    end
  end
end
