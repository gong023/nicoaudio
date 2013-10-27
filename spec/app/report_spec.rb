require 'spec_helper'

describe NicoMedia::Report do
  describe ":Log" do
    it "autoloaded" do
      expect { Report::Log }.not_to raise_error
    end
  end

  describe ":Twitter" do
    it "autoloaded" do
      expect { Report::Twitter }.not_to raise_error
    end
  end

  describe ":Normal" do
    it "autoloaded" do
      expect { Report::Normal }.not_to raise_error
    end
  end

  describe ":Abnormal" do
    it "autoloaded" do
      expect { Report::Abnormal }.not_to raise_error
    end
  end
end