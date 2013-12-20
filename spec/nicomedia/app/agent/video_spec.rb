require "spec_helper"

describe NicoMedia::Agent::Video do
  subject { described_class.exec("sm123") }

  describe "#exec" do
    context "failed with Net::HTTPClientError" do
      before do
        System.stub(:define_local_path).and_return("dummy")
        Agent.should_receive(:client).and_raise(Net::HTTPClientError)
        Report::Log.should_receive(:write).once
      end
      it "write fail log" do
        Record::History.instance.should_receive(:update_state).once
        expect { subject }.not_to raise_error
      end

      it "do not create file" do
        Kernel.should_not_receive(:open)
        expect { subject }.not_to raise_error
      end
    end
  end

  describe "#byte" do
    #context "with not using mock" do
    #  # 実際にgetflvを呼んで確かめるので普段はパス
    #  xit "return byte code" do
    #    expect(subject.byte("sm22197385").bytesize).not_to be 0
    #  end
    #end
  end
end
