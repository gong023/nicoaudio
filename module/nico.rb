require "niconico"
require "singleton"

class Nico < Base
  include Singleton
  attr_reader :agent, :record_history

  def init
    setting = Base.load_setting["nico"]
    @record_history = Record::History.new
    @agent = Niconico.new(setting["mail"], setting["pass"])
  end

  def login
    @agent.login
  end

end

Nico.instance.init

require_relative "./nico/ranking.rb"
require_relative "./nico/video.rb"
