require_relative "../../lib/base.rb"

test_setting = YAML.load_file(File.dirname(__FILE__) + "/../../test_setting.yaml")
describe Nico::Video do
  before do
    # fixme:ここらはマジでひどいのでどこまでmock使うかから考えたい
    YAML.stub(:load_file).and_return test_setting
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
      ["sm4", "video3", 1, '0000-00-00 00:00:00']
    ].each do |d|
      test_colums = "video_id, title, state, updated_at"
      test_values = "'#{d[0]}', '#{d[1]}', #{d[2]}, '#{d[3]}'"
      mysql.query("INSERT INTO history (#{test_colums}) VALUES (#{test_values})")
    end

  end

  describe "download_recently" do
    it "should update status" do
      Nico::Video.nico.stub_chain(:agent, :video, :get_video).and_return true
      Nico::Video.download_recently.should eq ["sm1", "sm2", "sm3"]
    end

    it "should create directory" do
      Dir.exists?(test_setting["system"]["video"]["save"]).should be true
    end

    it "should create mp4s" do
    end
  end

  describe "to_mp3" do
#    System.stub(:execute).and_return { |command| command }
  end
end
