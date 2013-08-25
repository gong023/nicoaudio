require "niconico"
require "singleton"
require "chronic"

class Nico < Base
  include Singleton
  attr_reader :agent, :record_history

  def init
    load_setting
    @record_history = Record::History.new
    @agent = Niconico.new(@setting["nico"]["mail"], @setting["nico"]["pass"])
  end

  def login
    @agent.login
  end

end

Nico.instance.init

require_relative "./nico/ranking.rb"
require_relative "./nico/video.rb"
