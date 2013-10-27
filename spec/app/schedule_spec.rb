require 'spec_helper'

describe NicoMedia::Schedule do
  describe ":Util" do
    it "autoloaded" do
      expect { Schedule::Util }.not_to raise_error
    end
  end

  describe ":Ranking" do
    it "autoloaded" do
      expect { Schedule::Ranking }.not_to raise_error
    end
  end
end