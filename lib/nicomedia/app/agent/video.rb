module NicoMedia
  class Agent
    class Video
      def self.download video_id
        Agent.client.video(video_id).get_video
      end
    end
  end
end
