require "spec_helper"

describe NicoMedia::System do
  describe ":S3" do
    it "autoloaded" do
      expect { System::S3 }.not_to raise_error
    end
  end

  describe ":File" do
    it "autoloaded" do
      expect { System::File }.not_to raise_error
    end
  end

  describe ":Find" do
    it "autoloaded" do
      expect { System::Find }.not_to raise_error
    end
  end

  describe ":Ffmpeg" do
    it "autoloaded" do
      expect { System::Ffmpeg }.not_to raise_error
    end
  end

  describe ":Directory" do
    it "autoloaded" do
      expect { System::Directory }.not_to raise_error
    end
  end

  describe "#execute" do
    subject { described_class }
    context "with success" do
      it "execute command" do
        expect { subject.execute("ls") }.not_to raise_error
      end
    end

    context "with unknown command" do
      it "raise error" do
        expect { subject.execute("unknown command") }.to raise_error
      end
    end

    context "with command with error status" do
      it "raise error" do
        expect { subject.execute("ls /unknown_dir ")}.to raise_error
      end
    end
  end

  describe "#define_local_path" do
    subject { described_class }
    let(:sample_video) { "sm123" }
    before do
      Record::History.instance.should_receive(:read_created_at).with(sample_video).and_return("2013-01-01")
    end
    context "with .mp4" do
      it "return video_root path" do
        expected_path = Setting.system["video"]["save"] + "/2013-01-01"
        expect(subject.define_local_path("#{sample_video}.mp4")).to eq expected_path
      end
    end

    context "with .mp3" do
      it "return audio_root path" do
        expected_path = Setting.system["audio"]["save"] + "/2013-01-01"
        expect(subject.define_local_path("#{sample_video}.mp3")).to eq expected_path
      end
    end
  end

  describe "#extension" do
    subject { described_class }
    context  "with type audio" do
      it "return .mp3" do
        expect(subject.extension("audio")).to eq ".mp3"
      end
    end

    context  "with type video" do
      it "return .mp4" do
        expect(subject.extension("video")).to eq ".mp4"
      end
    end
  end
end
