class Nico

  class Video
    @nico = Nico.instance

    class << self

      def download_recently
        ranking = Nico::Ranking.recently_from_record
        threads_fire(ranking, &download)
      end

      def download
        ->(list) do
          path = @nico.setting["system"]["video"]["save"] + list["created_at"]
          System::Directory.create(path)
          prc = ->() { @nico.agent.video(list["video_id"]).get_video }
          System::File.create(path + "#{list["video_id"]}.mp4", &prc)
        end
      end

      private
      def threads_fire(list, &prc)
        threads = []
        list.each { |l| threads << Thread.new() { yield(l) } }
        threads.each { |t| t.join }
      end

      private
      def fire(list, &prc)
        list.each { |l| yield(l["video_id"]); }
      end

    end
  end

end
