require 'spec_helper'

describe NicoMedia::System::Directory do
  let(:sample_date) { "2013-01-01" }
  subject { described_class }
  before do
    FileUtils.stub(:mkdir_p) { |create_path| create_path }
  end

  describe "#create_video_by_date" do
    context "with success" do
      it "create Directory with video root" do
        expected_path = Setting.system["video"]["save"] + sample_date
        expect(subject.create_video_by_date(sample_date)).to eq expected_path
      end
    end
  end

  describe "#create_audio_by_date" do
    context "with success" do
      it "create Directory with audio root" do
        expected_path = Setting.system["audio"]["save"] + sample_date
        expect(subject.create_audio_by_date(sample_date)).to eq expected_path
      end
    end
  end
end