require "spec_helper"

describe NicoMedia::Task::Hourly do
  subject { described_class }
  let(:safe_stubs) do
    Agent::Video.stub(:exec)
    System::Ffmpeg.stub(:exec)
    System::S3.stub(:exec)
    System::File.stub(:exist?).and_return(true)
    System::S3.stub(:exist?).and_return(true)
    Record.any_instance.stub(:execute)
  end

  describe "Hourly" do
    it "create steps dynamically" do
      expect(subject).to respond_to(:step_video)
      expect(subject).to respond_to(:step_audio)
      expect(subject).to respond_to(:step_s3)
    end
  end

  describe "step_video" do
    before { safe_stubs }

    context "deal state" do
      it "be :registerd when start downloading" do
        Record::History.instance.should_receive(:read_recently).with(:registerd).and_return([{"video_id" => "sm123"}])
        expect { subject.step_video }.not_to raise_error
      end

      it "be :downloaded when finish downloading" do
        Record::History.instance.should_receive(:read_recently).with(:registerd).and_return([{"video_id" => "sm123"}])
        Record::History.instance.should_receive(:update_state).with("sm123", :downloaded)
        expect { subject.step_video }.not_to raise_error
      end
    end

    context "executer" do
      it "not use thread" do
        Task.should_receive(:fire).once
        expect { subject.step_video }.not_to raise_error
      end
    end
  end

  describe "step_audio" do
    before { safe_stubs }

    context "deal state" do
      it "be :downloaded when start converting" do
        Record::History.instance.should_receive(:read_recently).with(:downloaded).and_return([{"video_id" => "sm123"}])
        expect { subject.step_audio }.not_to raise_error
      end

      it "be :converted when finish converting" do
        Record::History.instance.should_receive(:read_recently).with(:downloaded).and_return([{"video_id" => "sm123"}])
        Record::History.instance.should_receive(:update_state).with("sm123", :converted)
        expect { subject.step_audio }.not_to raise_error
      end
    end

    context "executer" do
      it "use thread" do
        Task.should_receive(:threads_fire).once
        expect { subject.step_audio }.not_to raise_error
      end
    end
  end

  describe "step_s3" do
    before { safe_stubs }

    context "deal state" do
      it "be :converted when start uploading" do
        Record::History.instance.should_receive(:read_recently).with(:converted).and_return([{"video_id" => "sm123"}])
        expect { subject.step_s3 }.not_to raise_error
      end

      it "be :converted when finish uploading" do
        Record::History.instance.should_receive(:read_recently).with(:converted).and_return([{"video_id" => "sm123"}])
        Record::History.instance.should_receive(:update_state).with("sm123", :uploaded)
        expect { subject.step_s3 }.not_to raise_error
      end
    end

    context "executer" do
      it "use thread" do
        Task.should_receive(:threads_fire).once
        expect { subject.step_s3 }.not_to raise_error
      end
    end
  end

  describe "#get_step_by_step" do
    before { safe_stubs }

    context "with fail" do
      it "call Report::Abnormal" do
        Agent::Ranking.should_receive(:filtered).with("music").and_raise(StandardError)
        Report::Abnormal.should_receive(:execute).once
        described_class.should_receive(:validate_file).once

        expect { subject.get_step_by_step }.not_to raise_error
      end
    end
  end
end
