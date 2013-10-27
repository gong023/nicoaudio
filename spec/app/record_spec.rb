require 'spec_helper'

describe NicoMedia::Record do
  let(:record) { Record.new }

  describe ":History" do
    it "autoloaded" do
      expect { Record::History }.not_to raise_error
    end
  end

  describe ".mysql" do
    it "loaded when initialized" do
      expect(record.mysql).to be_an_instance_of Mysql2::Client
    end
  end

  describe "#execute" do
    context "with correct query" do
      it "not raise error" do
        expect { record.execute("show tables") }.not_to raise_error
      end
    end

    context "with wrong query" do
      it "raise error" do
        expect { record.execute("wrong query")}.to raise_error
      end
    end
  end
end