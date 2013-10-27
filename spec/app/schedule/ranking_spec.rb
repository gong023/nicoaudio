require 'spec_helper'

describe NicoMedia::Schedule::Ranking do
  describe "#recently" do
    let(:sample_date) { Time.new("2013-01-01") }
    subject { described_class }
    before do
      Schedule::Util.stub(:parse_to_YmdHis).and_return(sample_date)
    end

    context "with success" do
      it "return hash" do
        expect(subject.recently).to have_key :from
        expect(subject.recently).to have_key :to
      end
    end
  end
end