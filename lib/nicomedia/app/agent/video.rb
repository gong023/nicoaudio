module NicoMedia
  class Agent
    class Video
      def self.download video_id
        ret = Agent.client.video(video_id).get_video
        ret
      end
    end
  end
end
