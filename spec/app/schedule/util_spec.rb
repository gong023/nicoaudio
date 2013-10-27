require 'spec_helper'

describe NicoMedia::Schedule::Util do
  let(:sample_date) { Time.new("2013-01-01 00:00:00 +0900") }
  subject { described_class }

  describe "#today" do
    before do
      Chronic.should_receive(:parse).with("today").and_return(sample_date)
    end

    context "with success" do
      it "return parsed string" do
        expect(subject.today).to eq "2013-01-01"
      end
    end
  end

  describe "parse_to_Ymd" do
    context "with success" do
      it "return parsed string" do
        expect(subject.parse_to_Ymd(sample_date)).to eq "2013-01-01"
      end
    end

    context "with wrong format string" do
      it "return nil" do
        expect(subject.parse_to_Ymd("wrong string")).to be_nil
      end
    end
  end

  describe "parse_to_YmdHis" do
    context "with success" do
      it "return parsed string" do
        expect(subject.parse_to_YmdHis(sample_date)).to eq "2013-01-01 00:00:00"
      end
    end

    context "with wrong format string" do
      it "return nil" do
        expect(subject.parse_to_YmdHis("wrong string")).to be_nil
      end
    end
  end
end