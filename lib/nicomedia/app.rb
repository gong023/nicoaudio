module NicoMedia
  class App
    def hourly
      begin
        Ranking.reload
        Report::Normal.execute[Video.method(:download_recently)][Video.method(:to_mp3)]
      rescue => e
        Report::Abnormal.execute e
      ensure
        validate_file
      end
    end

    private
    def validate_file
      System::Directory.create_video_by_date
      System::Directory.create_audio_by_date
      record = Record::History.new
      record.update_state(System::Find.mp4_by_date, Record::History::STATE_DOWNLOADED)
      record.update_state(System::Find.mp3_by_date, Record::History::STATE_CONVERTED)
    end

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

    def threads_fire(list, name)
      threads = []
      list.each { |l| threads << Thread.new() { self.method(name).call(l) } }
      threads.each { |t| t.join }
    end

    def fire(list, name)
      list.each &self.method(name)
    end

    def reload
      @nico.login
      ranks = URL.inject([]) { |ranks, category| @nico.agent.ranking(category) }
      to_record Filter_Music.detect(ranks)
    end

    def recently_from_record state
      schedule = Schedule::Ranking.recently
      w = "WHERE state = #{state} AND created_at between '#{schedule[:from]}' AND '#{schedule[:to]}'"
      @nico.record_history.read(w)
    end

    def to_record(rank, idx = 0)
      return if rank.count == idx + 1
      p = { video_id: rank[idx].keys[0], title: rank[idx].values[0], state: Record::History::STATE_UNDOWNLOADED }
      @nico.record_history.create(p)
      to_record(rank, idx + 1)
    end
  end
end
