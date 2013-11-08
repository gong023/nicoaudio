require "spec_helper"

describe NicoMedia::Agent::Video do
  subject { described_class }

  describe "#exec" do
    context "failed with Net::HTTPClientError" do
      before do
        System.stub(:define_local_path).and_return("dummy")
        System::Directory.should_receive(:create).and_raise(StandardError)
        Record::History.instance.should_receive(:update_state).once
        Report::Log.should_receive(:write).once
      end
      it "write fail log" do
        expect { subject.exec("sm123") }.not_to raise_error
      end
    end
  end

  describe "#get_video" do
    context "failed with Net::HTTPClientError" do
      before do
        Agent.should_receive(:client).and_raise(Net::HTTPNotFound)
        Record::History.instance.should_receive(:update_state).once
        Report::Log.should_receive(:write).once
      end
      it "write fail log" do
        expect { subject.get_video("sm123") }.not_to raise_error
      end
    end
  end
end
