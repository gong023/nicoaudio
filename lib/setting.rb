require "yaml"

module NicoMedia
  class Setting

    def initialize
      @file = File.dirname(__FILE__) + "/../setting.yaml"
    end

    def method_missing name, arg = nil
      setting = YAML.load_file(@file)
      if setting[name.to_s]
        return setting[name.to_s]
      else
        raise "unknown setting"
      end
    end
  end
end
