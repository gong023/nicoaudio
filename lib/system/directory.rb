require "fileutils"

class NicoSystem
  class Directory

    class << self
      def create path
        FileUtils.mkdir_p path
      end

      def create_video_by_date date = Schedule::Util.today
        create NicoSystem::VIDEO_ROOT + date
      end

      def create_audio_by_date date = Schedule::Util.today
        create NicoSystem::AUDIO_ROOT + date
      end
    end
  end
end
