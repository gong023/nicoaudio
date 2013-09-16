class Nico

  class Video
    @nico = Nico.instance

    class << self
      def nico; @nico; end

      def download_recently
        ranking = Nico::Ranking.recently_from_record Record::History::STATE_UNDOWNLOADED
        fire(ranking, :save) # cannot use threads.
        @nico.record_history.update_state(NicoSystem::Find.mp4_by_date, Record::History::STATE_DOWNLOADED)
      end

      def to_mp3
        unconverted_mp4s = Nico::Ranking.recently_from_record Record::History::STATE_DOWNLOADED
        threads_fire(unconverted_mp4s, :convert)
        @nico.record_history.update_state(NicoSystem::Find.mp3_by_date, Record::History::STATE_CONVERTED)
      end

      def save list
        path = NicoSystem::VIDEO_ROOT + Schedule::Util.parse_to_Ymd(list["created_at"])
        NicoSystem::Directory.create path
        prc = ->() { @nico.agent.video(list["video_id"]).get_video }
        NicoSystem::File.create(path + "/#{list["video_id"]}.mp4", &prc)
      end

      def convert list
        path_date = Schedule::Util.parse_to_Ymd(list["created_at"])
        NicoSystem::Directory.create NicoSystem::AUDIO_ROOT + path_date
        video_name = "#{NicoSystem::VIDEO_ROOT + path_date}/#{list['video_id']}.mp4"
        audio_name = "#{NicoSystem::AUDIO_ROOT + path_date}/#{list['video_id']}.mp3"
        NicoSystem::Ffmpeg.to_mp3(video_name, audio_name)
      end

      private
      def threads_fire(list, name)
        threads = []
        list.each { |l| threads << Thread.new() { self.method(name).call(l) } }
        threads.each { |t| t.join }
      end

      private
      def fire(list, name)
        list.each &self.method(name)
      end

    end
  end

end
