require "yaml"
require "pp"

class Base
  attr_reader :setting

  class << self

    def load_setting
      @setting = YAML.load_file(File.dirname(__FILE__) + "/../setting.yaml")
    end
  end

end

require_relative "./record.rb"
require_relative "./schedule.rb"
require_relative "./nico.rb"
require_relative "./system.rb"
