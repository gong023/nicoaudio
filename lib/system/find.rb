class NicoSystem
  class Find

    class << self
      def mp3_by_date date = Schedule::Util.today
        files = by_name(NicoSystem::AUDIO_ROOT + date, "*.mp3")
        pick_file_without_extension(files, /\.mp3$/)
      end

      def mp4_by_date date = Schedule::Util.today
        files = by_name(NicoSystem::VIDEO_ROOT + date, "*.mp4")
        pick_file_without_extension(files, /\.mp4$/)
      end

      def by_name(dir, pattern)
        NicoSystem::execute("find #{dir} -name '#{pattern}'")
      end

      private
      def pick_file systemu_str
        systemu_str.split("/").map! { |s| s.chomp! }.compact!
      end

      private
      def pick_dirfile systemu_str
        systemu_str.split("\n").map! { |s| s.delete("\n") }
      end

      private
      def pick_file_without_extension(systemu_str, extension)
        file_names = pick_file systemu_str
        file_names.nil? ? [] : file_names.map! { |s| s.gsub!(extension, "") }
      end

      private
      def pick_dirfile_without_extension(systemu_str, extension)
        file_names = pick_dirfile systemu_str
        file_names.nil? ? [] : file_names.map! { |s| s.gsub!(extension, "") }
      end
    end
  end
end
