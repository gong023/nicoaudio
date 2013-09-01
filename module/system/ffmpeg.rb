class System
  class Ffmpeg

    def self.to_mp3
      # XXX:fixme
      -> (id) do
        video_name = "#{System::VIDEO_ROOT + Schedule::Util.today}/#{id}.mp4"
        audio_name = "#{System::AUDIO_ROOT + Schedule::Util.today}/#{id}.mp3"
        System.execute("ffmpeg -i \"#{video_name}\" -ab 128 \"#{audio_name}\" < /dev/null")
      end
    end
  end
end
