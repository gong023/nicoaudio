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

        def exist? video_name
          ::File.exist? "#{System.define_local_path(video_name)}/#{video_name}"
        end

        def destroy video_name
          FileUtils.rm("#{System.define_local_path(video_name)}/#{name}")
        end
      end
    end
  end
end
