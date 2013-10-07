module NicoMedia
  class System
    class Ffmpeg
      def self.to_mp3(video_id, path_date)
        Directory.create AUDIO_ROOT + path_date
        video_name = "#{VIDEO_ROOT + path_date}/#{video_id}.mp4"
        audio_name = "#{AUDIO_ROOT + path_date}/#{video_id}.mp3"
        System.execute("ffmpeg -y -i \"#{video_name}\" -ab 128 \"#{audio_name}\" < /dev/null")
        true # XXX:fixme
      end
    end
  end
end
