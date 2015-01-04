require_relative "../../../vendor/niconico/lib/niconico.rb"

require "singleton"
module NicoMedia
  class Agent
    include Singleton
    autoload :Ranking, "agent/ranking"
    autoload :Video,   "agent/video"

    attr_reader :niconico

    def initialize
      setting = Setting.nico
      @niconico = Niconico.new(setting["mail"], setting["pass"])
    end

    def self.client
      Agent.instance.niconico
    end
  end
end
