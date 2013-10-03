require "niconico"
require "singleton"

module NicoMedia
  class App
    include Singleton
    attr_reader :agent, :record_history

    def init
      setting = Setting.new.nico
      @record_history = Record::History.new
      @agent = Niconico.new(setting["mail"], setting["pass"])
    end

    def hourly_task
      begin
        Ranking.reload
        Report::Normal.execute[Video.method(:download_recently)][Video.method(:to_mp3)]
      rescue => e
        Report::Abnormal.execute e
      ensure
        System::Directory.create_video_by_date
        System::Directory.create_audio_by_date
        record = Record::History.new
        record.update_state(System::Find.mp4_by_date, Record::History::STATE_DOWNLOADED)
        record.update_state(System::Find.mp3_by_date, Record::History::STATE_CONVERTED)
      end
    end

    def login
      @agent.login
    end
  end

  NicoMedia::App.instance.init ## fixme
  require_relative "./app/ranking"
  require_relative "./app/video"
end
