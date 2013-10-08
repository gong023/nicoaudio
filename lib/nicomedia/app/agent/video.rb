module NicoMedia
  class Agent
    class Video
      def self.download video_id
        path_date = Record::History.new.read_created_at video_id
        prc = ->() { Agent.client.video(video_id).get_video }
        System::File.create_mp4(list["video_id"], path_date, &prc)
      end
    end
  end
end
