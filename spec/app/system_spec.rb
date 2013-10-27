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
end
