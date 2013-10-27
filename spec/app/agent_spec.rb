require 'spec_helper'

describe NicoMedia::Agent do
  describe ":Ranking" do
    it "autoloaded" do
      expect { Agent::Ranking }.not_to raise_error
    end
  end

  describe ":Video" do
    it "autoloaded" do
      expect { Agent::Video }.not_to raise_error
    end
  end

  describe "#client" do
    let!(:client) { Agent.client }

    context "with success" do
      it "be singleton" do
        expect(client).to be Agent.client
      end

      it "instance of Niconico" do
        expect(client).to be_an_instance_of Niconico
      end
    end
  end
end