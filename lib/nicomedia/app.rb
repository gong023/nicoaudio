module NicoMedia
  class App
    def initialize
      @record_history = Record::History.new
      @step_count = 0
      self.class.create_step
    end

    def hourly
      begin
        @record_history.create_new Agent::Ranking.filtered "music"
        Report::Normal.execute[method(:step_video)][method(:step_audio)][method(:step_s3)]
      rescue => e
        Report::Abnormal.execute e
      ensure
        validate_file
      end
    end

    FILE_STATES = %i(registerd downloaded converted uploaded).freeze

    STEP = {
        video: {
            type: "video",
            client: Agent::Video,
            checker: System::File
        },
        audio: {
            type: "audio",
            client: System::Ffmpeg,
            checker: System::File
        },
        s3: {
            type: "audio",
            client: System::S3,
            checker: System::S3
        }
    }

    def self.create_step
      STEP.each do |k, v|
        define_method "step_#{k}" do
          next_state = FILE_STATES[@step_count + 1]
          targets = @record_history.read_recently FILE_STATES[@step_count]
          target_executer = k == :video ? method(:fire) : method(:threads_fire)
          target_executer.call(targets) do |list|
            video_id = list["video_id"]
            v[:client].method(:exec).call(video_id)
            @record_history.update_state([video_id], next_state) if v[:checker].method(:exist?).call(v[:type], video_id)
          end
          @step_count += 1
        end
      end
    end

    private
    def validate_file
      today = Schedule::Util.today
      System::Directory.create_video_by_date today
      System::Directory.create_audio_by_date today
      @record_history.update_state(System::Find.mp4_by_date(today), :downloaded)
      @record_history.update_state(System::Find.mp3_by_date(today), :converted)
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
