require 'spec_helper'

describe NicoMedia::System::Find do
  subject { described_class }
  let(:sample_with_mp3) { "/dir/music/2013-01-01/sm123.mp3\n/dir/music/2013-01-01/sm456.mp3\n" }
  let(:sample_with_mp4) { "/dir/movie/2013-01-01/sm789.mp4\n/dir/movie/2013-01-01/sm012.mp4\n" }
  let(:system_stub) do
    System.stub(:execute) do |cmd|
      raise "only find is expected to be called" unless cmd =~ /^find/
      if cmd =~ /\.mp3\'$/
        sample_with_mp3
      else
        sample_with_mp4
      end
    end
  end

  describe "singleton class" do
    it "create method dynamically" do
      expect(subject).to respond_to(:mp3_by_date)
      expect(subject).to respond_to(:mp4_by_date)
      expect(subject).to respond_to(:pick_file_without_extension)
      expect(subject).to respond_to(:pick_dirfile_without_extension)
    end
  end

  describe "#pick_file" do
    context "with_success" do
      it "return file name" do
        expect(subject.pick_file(sample_with_mp3)).to eq ["sm123.mp3", "sm456.mp3"]
      end
    end

    context "with failure" do
      it "return empty array" do
        expect(subject.pick_file("wrong string")).to eq []
      end
    end
  end

  describe "#pick_dirfile" do
    context "with success" do
      it "return filename with dirname" do
        expected_array = ["/dir/music/2013-01-01/sm123.mp3", "/dir/music/2013-01-01/sm456.mp3"]
        expect(subject.pick_dirfile(sample_with_mp3)).to eq expected_array
      end
    end

    context "with not match" do
      it "return string received" do
        expect(subject.pick_dirfile("not match string")).to be_nil
      end
    end
  end

  describe "#pick_file_without_extension" do
    context "with success" do
      it "return video_id only" do
        expect(subject.pick_file_without_extension(sample_with_mp3, ".mp3")).to eq ["sm123", "sm456"]
        expect(subject.pick_file_without_extension(sample_with_mp4, ".mp4")).to eq ["sm789", "sm012"]
      end
    end

    context "with failure" do
      it "return epmty array" do
        expect(subject.pick_file_without_extension("wrong string", ".mp3")).to eq []
      end
    end
  end

  describe "#pick_dirfile_without_extension" do
    context "with success" do
      it "return video_id only" do
        expected_array = ["/dir/music/2013-01-01/sm123", "/dir/music/2013-01-01/sm456"]
        expect(subject.pick_dirfile_without_extension(sample_with_mp3, ".mp3")).to eq expected_array
      end
    end

    context "with failure" do
      it "return epmty array" do
        expect(subject.pick_dirfile_without_extension("wrong string", ".mp3")).to eq []
      end
    end
  end

  describe "#mp3_by_date" do
    before do
      system_stub
    end

    context "with success" do
      it "return video_id array" do
        expect(subject.mp3_by_date("2013-01-01")).to eq ["sm123", "sm456"]
      end
    end
  end

  describe "#mp4_by_date" do
    before do
      system_stub
    end

    context "return video_id array" do
      it "return video)id array" do
        expect(subject.mp4_by_date("2013-01-01")).to eq ["sm789", "sm012"]
      end
    end
  end
end
