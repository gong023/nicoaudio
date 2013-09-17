class NicoSystem
  class Find

    class << self

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

      # define pick_file_without_extension, pick_dirfile_without_extension
      %i(pick_file pick_dirfile).each do |method_type|
        define_method "#{method_type}_without_extension".to_sym do |systemu_str, extension|
          file_names = self.method(method_type).call(systemu_str)
          file_names.nil? ? [] : file_names.map! { |s| s.gsub!(extension, "") }
        end
      end

      # define mp3_by_date, mp4_by_date
      %w(mp3 mp4).each do |method_type|
        define_method("#{method_type}_by_date", ->(date = nil) {
          date = Schedule::Util.today if date.nil?
          const = (method_type == "mp3") ? NicoSystem::AUDIO_ROOT : NicoSystem::VIDEO_ROOT
          files = by_name(const + date, "*.#{method_type}")
          pick_file_without_extension(files, /\.#{method_type}$/)
        })
      end
    end
  end
end
