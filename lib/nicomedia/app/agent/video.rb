module NicoMedia
  class Agent
    class Video
      def self.exec video_id
        path_date = Record::History.instance.read_created_at video_id
        prc = ->() { Agent.client.video(video_id).get_video }
        System::File.create_mp4(video_id, path_date, &prc)
      end
    end
  end
end
