module NicoMedia
  class App
    class Video
      @nico = App.instance
      class << self
        def download_recently
          ranking = Ranking.recently_from_record Record::History::STATE_UNDOWNLOADED
          fire(ranking, :save) # cannot use threads.
          @nico.record_history.update_state(System::Find.mp4_by_date, Record::History::STATE_DOWNLOADED)
        end

        def to_mp3
          unconverted_mp4s = Ranking.recently_from_record Record::History::STATE_DOWNLOADED
          threads_fire(unconverted_mp4s, :convert)
          @nico.record_history.update_state(System::Find.mp3_by_date, Record::History::STATE_CONVERTED)
        end

        def save list
          path_date = Schedule::Util.parse_to_Ymd(list["created_at"])
          prc = ->() { @nico.agent.video(list["video_id"]).get_video }
          System::File.create_mp4(list["video_id"], path_date, &prc)
        end

        def convert list
          path_date = Schedule::Util.parse_to_Ymd(list["created_at"])
          System::Ffmpeg.to_mp3(list['video_id'], path_date)
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
end
