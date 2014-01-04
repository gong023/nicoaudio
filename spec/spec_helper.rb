$:.concat Dir.glob(File.dirname(File.dirname(__FILE__)) + "/lib/**/")
require "nicomedia"
include NicoMedia

NicoMedia::Setting.file = File.dirname(__FILE__) + "/../test_setting.yml"
