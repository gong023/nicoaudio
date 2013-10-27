require "yaml"
module NicoMedia
  class Setting
    @file = File.dirname(__FILE__) + "/../../../setting.yaml"

    class << self
      attr_accessor :file

      def method_missing(m, a = nil)
        return if m.to_s == "to_ary"
        setting = YAML.load_file(@file)
        if setting[m.to_s]
          return setting[m.to_s]
        else
          raise "unknown setting"
        end
      end
    end
  end
end
