class NicoSystem
  class Ffmpeg

    def self.to_mp3
      # XXX:fixme
      -> (id) do
        # XXX:fixmefixmefime
        video_name = "#{NicoSystem::VIDEO_ROOT + Schedule::Util.today}/#{id}.mp4"
        audio_name = "#{NicoSystem::AUDIO_ROOT + Schedule::Util.today}/#{id}.mp3"
        NicoSystem.execute("ffmpeg -i \"#{video_name}\" -ab 128 \"#{audio_name}\" < /dev/null")
        nil #gyaaaaaaaaaaaaaaaaaaaaa
      end
    end
  end
end
