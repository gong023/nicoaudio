module NicoMedia
  class System
    class Ffmpeg
      def self.exec video_id
        path_date = Record::History.instance.read_created_at video_id
        Directory.create AUDIO_ROOT + path_date
        video_name = "#{VIDEO_ROOT + path_date}/#{video_id}.mp4"
        audio_name = "#{AUDIO_ROOT + path_date}/#{video_id}.mp3"
        System.execute("ffmpeg -y -i \"#{video_name}\" -ab 128 \"#{audio_name}\" < /dev/null")
        true # XXX:fixme
      end
    end
  end
end
