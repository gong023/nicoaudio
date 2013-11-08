module NicoMedia
  class Agent
    class Video
      def self.exec video_id
        System::File.create_mp4(video_id) { method(:get_video).call(video_id) }
      rescue # XXX:fixme
        Record::History.instance.update_state(video_id, :invalid)
        Report::Log.write("video", "#{video_id} / error", "fail")
      end

      def self.get_video video_id
        Agent.client.video(video_id).get_video
      rescue # XXX:fixme Net::HTTPClientError, Net::HTTPServerError
        Record::History.instance.update_state(video_id, :invalid)
        Report::Log.write("video", "#{video_id} / error", "fail")
      end
    end
  end
end
