module NicoMedia
  class App
    def initialize
      @record_history = Record::History.new
    end

    def hourly
      begin
        to_record Agent::Ranking.filtered "music"
        Report::Normal.execute[method(:download_recently)][method(:to_mp3)]
      rescue => e
        Report::Abnormal.execute e
      ensure
        validate_file
      end
    end

    private
    def download_recently
      ranking = recently_from_record :undownloaded
      fire(ranking, :save) # cannot use threads.
      @record_history.update_state(System::Find.mp4_by_date, :downloaded)
    end

    def to_mp3
      unconverted_mp4s = recently_from_record :downloaded
      threads_fire(unconverted_mp4s, :convert)
      @record_history.update_state(System::Find.mp3_by_date, :converted)
    end

    def save list
      path_date = Schedule::Util.parse_to_Ymd(list["created_at"])
      prc = ->() { Agent::Video.download(list["video_id"]) }
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

    def recently_from_record state
      state = Record::History.const_get("STATE_#{state.upcase}")
      sch = Schedule::Ranking.recently
      w = "WHERE state = #{state} AND created_at between '#{sch[:from]}' AND '#{sch[:to]}'"
      @record_history.read(w)
    end

    def to_record(rank, idx = 0)
      return if rank.count == idx + 1
      p = { video_id: rank[idx].keys[0], title: rank[idx].values[0], state: Record::History::STATE_UNDOWNLOADED }
      @record_history.create(p)
      to_record(rank, idx + 1)
    end

    def validate_file
      System::Directory.create_video_by_date
      System::Directory.create_audio_by_date
      @record_history.update_state(System::Find.mp4_by_date, :downloaded)
      @record_history.update_state(System::Find.mp3_by_date, :converted)
    end

  end
end
