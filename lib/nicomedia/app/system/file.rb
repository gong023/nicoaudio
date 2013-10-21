module NicoMedia
  class System
    class File
      class << self
        def create_mp4(name, path_date, &prc)
          path = VIDEO_ROOT + path_date
          Directory.create path
          create("#{path}/#{name}.mp4", &prc)
        end

        def create(name, &prc)
          $stdout = open(name, "w")
          puts yield
          $stdout.flush
        end

        def exist?(type, video_id)
          path = type == "audio" ? AUDIO_ROOT : VIDEO_ROOT
          extension = type == "audio" ? ".mp3" : ".mp4"
          path_date = Record::History.instance.read_created_at video_id
          ::File.exist? "#{path}/#{path_date}/#{video_id}#{extension}"
        end

        def destroy(path, name)
          FileUtils.rm("#{path}/#{name}")
        end
      end
    end
  end
end
