module NicoMedia
  class System
    class File
      def self.create_mp4(name, path_date, &prc)
        path = VIDEO_ROOT + path_date
        Directory.create path
        create("#{path}/#{name}.mp4", &prc)
      end

      def self.create(name, &prc)
        $stdout = open(name, "w")
        puts yield
        $stdout.flush
      end
    end
  end
end
