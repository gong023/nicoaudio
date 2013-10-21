require "niconico"
module NicoMedia
  class Agent
    include Singleton
    attr_reader :niconico

    def initialize
      setting = Setting.new.nico
      @niconico = Niconico.new(setting["mail"], setting["pass"])
    end

    def self.client
      Agent.instance.niconico
    end
    require_relative "./agent/ranking"
    require_relative "./agent/video"
  end
end
