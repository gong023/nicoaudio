module NicoMedia
  class App
    def initialize
      @record_history = Record::History.new
    end

    def hourly
      begin
        @record_history.create_new Agent::Ranking.filtered "music"
        Report::Normal.execute[method(:download_mp4)][method(:convert_to_mp3)][method(:upload_to_s3)]
      rescue => e
        Report::Abnormal.execute e
      ensure
        validate_file
      end
    end

    private
    def download_mp4
      ranking = @record_history.read_recently :undownloaded
      fire(ranking, :download) # cannot use threads.
    end

    def convert_to_mp3
      unconverted_mp4s = @record_history.read_recently :downloaded
      threads_fire(unconverted_mp4s, :convert)
    end

    def upload_to_s3
      exists_in_local = @record_history.read_recently :converted
      exists_in_local.each {|l| p l}
      # XXX:fixme
      threads_fire(exists_in_local, "dummy") do |l|
        s3 = System::S3.new
        s3.upload_multi l["video_id"]
        @record_history.update_state([l["video_id"]], :uploaded) if s3.exists?("#{l["video_id"]}.mp3")
      end
    end

    def validate_file
      today = Schedule::Util.today
      System::Directory.create_video_by_date today
      System::Directory.create_audio_by_date today
      @record_history.update_state(System::Find.mp4_by_date(today), :downloaded)
      @record_history.update_state(System::Find.mp3_by_date(today), :converted)
    end

    def download list
      path_date = Schedule::Util.parse_to_Ymd(list["created_at"])
      prc = ->() { Agent::Video.download(list["video_id"]) }
      System::File.create_mp4(list["video_id"], path_date, &prc)
      @record_history.update_state(System::Find.mp4_by_date(path_date), :downloaded)
    end

    def convert list
      path_date = Schedule::Util.parse_to_Ymd(list["created_at"])
      System::Ffmpeg.to_mp3(list["video_id"], path_date)
      @record_history.update_state(System::Find.mp3_by_date(path_date), :converted)
    end

    def threads_fire(list, name)
      threads = []
      # XXX:fixme
      if block_given?
        list.each { |l| threads << Thread.new() { yield(l) } }
      else
        list.each { |l| threads << Thread.new() { self.method(name).call(l) } }
      end
      threads.each { |t| t.join }
    end

    def fire(list, name)
      list.each &self.method(name)
    end

  end
end
