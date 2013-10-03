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

    def login
      @agent.login
    end

  end

  NicoMedia::App.instance.init ## fixme
  require_relative "./app/ranking"
  require_relative "./app/video"
end
