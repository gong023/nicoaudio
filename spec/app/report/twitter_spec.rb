require 'spec_helper'

describe NicoMedia::Report::Twitter do
  subject { Report::Twitter.new }

  describe "#optimaze" do
    context "with_success" do
      it "make message less than 140" do
        over_msg = 150.times.inject("a") {|m, n| "#{m}#{n}" }
        expect(subject.optimaze(over_msg).size).to be < 140
      end
    end
  end
end