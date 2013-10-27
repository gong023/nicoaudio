require "spec_helper"

describe NicoMedia::Setting do
  describe ".file" do
    it "load test_setting.yaml under spec directory" do
      expect(Setting.file).to match /test_setting\.yaml$/
    end
  end

  describe "#method_missing" do
    context "with setting exist" do
      it "load setting dynamically" do
        expected_setting = YAML.load_file(File.dirname(__FILE__)+"/../../test_setting.yaml")

        expect(Setting.nico).to eq expected_setting["nico"]
        expect(Setting.mysql).to eq expected_setting["mysql"]
        expect(Setting.system).to eq expected_setting["system"]
      end
    end

    context "with setting not exist" do
      it "raise error" do
        expect {Setting.unknown_setting}.to raise_error
      end
    end
  end
end