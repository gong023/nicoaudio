module NicoMedia
  class Agent
    class Video
      def self.exec video_id
        path_date = Record::History.instance.read_created_at video_id
        prc = ->() { Agent.client.video(video_id).get_video }
        begin
          System::File.create_mp4(video_id, path_date, &prc)
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
end
