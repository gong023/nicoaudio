require 'spec_helper'

describe NicoMedia::System::S3 do
  subject { described_class }
  let(:sample_id) { "sm123" }

  describe "#define_remote_path" do
    context "with audio name" do
      before do
        Record::History.instance.should_receive(:read_created_at).with("#{sample_id}.mp3").and_return("2013-01-01")
      end
      it "return audio path" do
        expect(subject.define_remote_path("#{sample_id}.mp3")).to eq "audio/2013-01-01"
      end
    end

    context "with video name" do
      before do
        Record::History.instance.should_receive(:read_created_at).with("#{sample_id}.mp4").and_return("2013-01-01")
      end
      it "return video path" do
        expect(subject.define_remote_path("#{sample_id}.mp4")).to eq "video/2013-01-01"
      end
    end
  end

  describe "#define_content_type" do
    context "with audio name" do
      it "return audio/mpeg" do
        expect(subject.define_content_type("#{sample_id}.mp3")).to eq "audio/mpeg"
      end
    end

    context "with video name" do
      it "return video/mp4" do
        expect(subject.define_content_type("#{sample_id}.mp4")).to eq "video/mp4"
      end
    end
  end
end