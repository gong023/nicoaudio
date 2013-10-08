module NicoMedia
  class App
    @record_history = Record::History.new
    def hourly
      begin
        @record_history.create_new Agent::Ranking.filtered "music"
        Report::Normal.execute[method(:step_undownload)][method(:step_downloaded)][method(:step_convert)]
      rescue => e
        Report::Abnormal.execute e
      ensure
        validate_file
      end
    end

    STEP = [
        {
            state: :undownload,
            type: "video",
            client: Agent::Video,
            checker: System::File
        },
        {
            state: :downloaded,
            type: "audio",
            client: System::Ffmpeg,
            checker: System::File
        },
        {
            state: :convert,
            type: "audio",
            client: System::S3,
            checker: System::S3
        }
    ].each_index do |step|
      next_state = STEP.at(step + 1) ? STEP.at(step + 1)[:state] : :uploaded
      define_method "step_#{step[:state]}" do
        targets = @record_history.read_recently state
        executer = step[:state] == :undownloaded ? self.method(:fire) ? self.method(:threads_fire)
        executer.call(targets) do |list|
          video_id = list["video_id"]
          step[:client].method(:exec).call(video_id)
          @record_history.update_state([video_id], next_state) if step[:checker].method(:exist?).call(step[:type], video_id)
        end
      end
    end

    private
    def validate_file
      today = Schedule::Util.today
      System::Directory.create_video_by_date today
      System::Directory.create_audio_by_date today
      @record_history.update_state(System::Find.mp4_by_date(today), :downloaded)
      @record_history.update_state(System::Find.mp3_by_date(today), :convert)
    end

    def threads_fire list
      threads = []
      list.each { |l| threads << Thread.new() { yield(l) } }
      threads.each { |t| t.join }
    end

    def fire list
      list.each { |l| yield(l) }
    end
  end
end
