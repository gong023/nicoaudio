require 'spec_helper'

describe NicoMedia::System::S3 do
  let(:sample_id) { "sm123" }

  describe "#define_remote_path" do
    subject { described_class.define_remote_path(media) }
    context "with audio name" do
      let(:media) { "#{sample_id}.mp3" }
      before do
        Record::History.instance.should_receive(:read_created_at).with("#{sample_id}.mp3").and_return("2013-01-01")
      end
      it { expect(subject).to eq "audio/2013-01-01" }
    end

    context "with video name" do
      let(:media) { "#{sample_id}.mp4" }
      before do
        Record::History.instance.should_receive(:read_created_at).with("#{sample_id}.mp4").and_return("2013-01-01")
      end
      it { expect(subject).to eq "video/2013-01-01" }
    end
  end

  describe "#define_content_type" do
    subject { described_class.define_content_type(media) }
    context "with audio name" do
      let(:media) { "#{sample_id}.mp3" }
      it { expect(subject).to eq "audio/mpeg" }
    end

    context "with video name" do
      let(:media) { "#{sample_id}.mp4" }
      it { expect(subject).to eq "video/mp4" }
    end
  end
end