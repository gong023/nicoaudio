require_relative "../../lib/base.rb"

# もはや考えることを諦めた
def apply_fixture
  # fixme:ここらはマジでひどいのでどこまでmock使うかから考えたい
  # YAML.should_receive(:load_file).and_return test_setting
  test_setting = YAML.load_file(File.dirname(__FILE__) + "/../../test_setting.yaml")
  mysql = Mysql2::Client.new(
    :host     => test_setting["mysql"]["host"],
    :username => test_setting["mysql"]["user"],
    :password => test_setting["mysql"]["password"],
    :database => test_setting["mysql"]["database"]
  )
  mysql.query("DELETE FROM history")
  [
    ["sm1", "video1", 0, '0000-00-00 00:00:00'],
    ["sm2", "video2", 0, '0000-00-00 00:00:00'],
    ["sm3", "video3", 0, '0000-00-00 00:00:00'],
    ["sm4", "video3", 1, '0000-00-00 00:00:00'],
    ["sm5", "video3", 1, '0000-00-00 00:00:00'],
    ["sm6", "video3", 2, '0000-00-00 00:00:00']
  ].each do |d|
    test_colums = "video_id, title, state, updated_at"
    test_values = "'#{d[0]}', '#{d[1]}', #{d[2]}, '#{d[3]}'"
    mysql.query("INSERT INTO history (#{test_colums}) VALUES (#{test_values})")
  end
end

describe Nico::Video do
  test_setting = YAML.load_file(File.dirname(__FILE__) + "/../../test_setting.yaml")

  describe "download_recently" do
    before do
      apply_fixture
    end
    it "should update status" do
      Nico::Video.nico.stub_chain(:agent, :video, :get_video).and_return true
      Nico::Video.download_recently.should eq ["sm1", "sm2", "sm3"]
    end

    it "should create directory" do
      Dir.exists?(test_setting["system"]["video"]["save"]).should eq true
    end

    it "should create mp4s" do
      p = test_setting["system"]["video"]["save"] + Time.now.to_s.match(/^\d{4}-\d{2}-\d{2}/)[0]
      File.exists?(p + "/sm1.mp4").should eq true
      File.exists?(p + "/sm2.mp4").should eq true
      File.exists?(p + "/sm3.mp4").should eq true
    end
  end

  describe "to_mp3" do
    before do
      apply_fixture
      NicoSystem::Ffmpeg.should_receive(:to_mp3).and_return true
    end

    it "should create mp3s" do
      Nico::Video.to_mp3

      p = test_setting["system"]["audio"]["save"] + Time.now.to_s.match(/^\d{4}-\d{2}-\d{2}/)[0]
      File.exists?(p + "/sm4.mp3").should eq true
      File.exists?(p + "/sm5.mp3").should eq true
    end
  end
end
