module NicoMedia
  class Task
    autoload :Hourly, "task/hourly"
    autoload :Dump,   "task/dump"

    FILE_STATES = %i(registerd downloaded converted uploaded).freeze

    STEP = {
        video: {
            client: Agent::Video,
            checker: System::File
        },
        audio: {
            client: System::Ffmpeg,
            checker: System::File
        },
        s3: {
            client: System::S3,
            checker: System::S3
        }
    }

    def self.threads_fire list
      threads = []
      list.each { |l| threads << Thread.new() { yield(l) } }
      threads.each { |t| t.join }
    end

    def self.fire list
        list.each { |l| yield(l) }
    end
  end
end
