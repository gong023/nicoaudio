require "yaml"

class Setting
  def load
    YAML.load_file(File.dirname(__FILE__) + "/../setting.yaml")
  end
end
