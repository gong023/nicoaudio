require "spec_helper"

describe NicoMedia::App::Dump do
  subject { described_class.new }

  describe "#all_by_rand" do
    context "with record not found" do
      before do
        Record::History.instance.should_receive(:read).once.and_return([])
      end
      it "break roop" do
        expect { subject.all_by_rand }.not_to raise_error
      end
    end

    context "with raise error" do
      before do
        Record::History.instance.stub(:within_shared_lock).and_raise(StandardError)
        Record::History.instance.stub(:read).and_return(["dummy"], [])
        Report::Abnormal.should_receive(:execute).once
      end

      it "write abnomal log and do next loop forcibly" do
        expect { subject.all_by_rand }.not_to raise_error
      end
    end
  end

  describe "#report_interval" do
    context "with regular interval" do
      before do
        subject.report_count = 10
        Report::Twitter.any_instance.stub(:send_dm)
        Report::Log.should_receive(:write).once
      end
      it "send twitter DM" do
        expect { subject.report_interval("sm123") }.not_to raise_error
      end

      let!(:before_ended_ids) { subject.ended_ids }
      it "overwrite ended_ids" do
        subject.report_interval("sm123")
        expect(subject.ended_ids).not_to eq before_ended_ids
      end
    end
  end

  describe "#record_history" do
    it "memo Record::History" do
      expect(subject.record_history).to be subject.record_history
      expect(subject.record_history).to be_an_instance_of Record::History
    end
  end
end
