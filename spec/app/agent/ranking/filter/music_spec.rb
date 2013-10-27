require 'spec_helper'

describe NicoMedia::Agent::Ranking::Filter_Music do
  subject { described_class }
  let(:row_ranking) do
    d1, d2, d3 = double(:Niconico_Video, id: 0), double(:Niconico_Video, id: 1), double(:Niconico_Video, id: 3)
    d1.should_receive(:title).at_least(:once).and_return("初音ミクさんの動画")
    d2.should_receive(:title).at_least(:once).and_return("歌ってみた動画")
    d3.should_receive(:title).at_least(:once).and_return("実況動画")
    [ d1, d2, d3 ]
  end

  describe "#squeeze" do
    context "with success" do
      it "contains 初音ミク, 歌ってみた" do
        expected_array = [ {0 => "初音ミクさんの動画"}, {1 => "歌ってみた動画"} ]
        expect(subject.squeeze(row_ranking)).to eq expected_array
      end

      it "abort 実況動画" do
        subject.squeeze(row_ranking).each_with_index do |ret, i|
          expect(ret[i]).not_to match /実況/
        end
      end
    end
  end
end