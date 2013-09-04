class Nico

  class Video
    @nico = Nico.instance

    class << self

      def download_recently
        ranking = Nico::Ranking.recently_from_record
        fire(ranking, :save) # cannot use threads.
        @nico.record_history.update_state_dowloaded System::Find.mp4_by_date
      end

      def to_mp3
        System::Directory.create_audio_by_date
        unconverted_mp4s =  System::Find.mp4_by_date - System::Find.mp3_by_date
        to_mp3 = System::Ffmpeg.to_mp3
        threads_fire(unconverted_mp4s, &to_mp3)
      end

      def save list
        path = System::VIDEO_ROOT + Schedule::Util.parse_to_Ymd(list["created_at"])
        System::Directory.create(path)
        prc = ->() { @nico.agent.video(list["video_id"]).get_video }
        System::File.create(path + "/#{list["video_id"]}.mp4", &prc)
      end

      private
      def threads_fire(list, &prc)
        threads = []
        list.each { |l| threads << Thread.new() { yield(l) } }
        threads.each { |t| t.join }
      end

      private
      def fire(list, name)
        list.each &method(name)
      end

    end
  end

end
