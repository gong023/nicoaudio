module NicoMedia
  class System
    class Ffmpeg
      def self.to_mp3(video_name, audio_name)
        System.execute("ffmpeg -i \"#{video_name}\" -ab 128 \"#{audio_name}\" < /dev/null")
        true # XXX:fixme
      end
    end
  end
end
