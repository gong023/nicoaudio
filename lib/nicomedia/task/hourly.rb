module NicoMedia
  class Task
    class Hourly
      @record_history = Record::History.instance

      Task::STEP.each_with_index do |step, i|
        media, executer = step.first, step.last
        self.singleton_class.send(:define_method, "step_#{media}") do
          next_state = Task::FILE_STATES[i + 1]
          extension = media == :video ? ".mp4" : ".mp3"
          targets = @record_history.read_recently Task::FILE_STATES[i]
          Task.fire(targets) do |list|
            video_id = list["video_id"]
            executer[:client].method(:exec).call(video_id)
            @record_history.update_state(video_id, next_state) if executer[:checker].method(:exist?).call("#{video_id}#{extension}")
          end
        end
      end

      class << self
        def get_step_by_step
          @record_history.create_new Agent::Ranking.filtered "music"
          Report::Normal.hourly[method(:step_video)][method(:step_audio)][method(:step_s3)]
        rescue => e
          Report::Abnormal.execute e
        ensure
          validate_file
        end

        def validate_file
          today = Schedule::Util.today
          System::Directory.create_video_by_date today
          System::Directory.create_audio_by_date today
          @record_history.update_state(System::Find.mp4_by_date(today), :downloaded)
          @record_history.update_state(System::Find.mp3_by_date(today), :converted)
          @record_history.update_state(System::S3.find_by_date("audio", today), :uploaded)
          Task.fire(@record_history.read_recently(:uploaded)) do |list|
            System::File.destroy("#{list["video_id"]}.mp4") if System::File.exist?("#{list["video_id"]}.mp4")
          end
        rescue => e
          Report::Log.write("exception", "#{e.message} / #{e.backtrace}", "fail")
        end
      end
    end
  end
end
