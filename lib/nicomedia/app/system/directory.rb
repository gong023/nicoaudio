require "fileutils"
module NicoMedia
  class System
    class Directory
      class << self
        def create path
          FileUtils.mkdir_p path
        end

        def create_video_by_date date
          create VIDEO_ROOT + date
        end

        def create_audio_by_date date
          create AUDIO_ROOT + date
        end
      end
    end
  end
end
