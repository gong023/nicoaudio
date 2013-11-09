module NicoMedia
  class System
    class File
      class << self
        def create_mp4(video_id, &prc)
          create(System.define_local_path("#{video_id}.mp4"), "#{video_id}.mp4", &prc)
        end

        def create(path, name, &prc)
          byte = yield
          Directory.create path
          $stdout = open("#{path}/#{name}", "w")
          puts byte
          $stdout.flush
        end

        def exist? video_name
          pathname = "#{System.define_local_path(video_name)}/#{video_name}"
          ::File.exist?(pathname)  && ! ::File.zero?(pathname)
        end

        def destroy video_name
          FileUtils.rm "#{System.define_local_path(video_name)}/#{video_name}"
        end
      end
    end
  end
end
