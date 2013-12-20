require 'spec_helper'

describe NicoMedia::Agent::Ranking do
  subject { described_class }
  let(:all_rank) { ["総合カテゴリランキング1位", "音楽カテゴリランキング1位"] }

  describe "#all" do
    #context "with not using mock" do
    #  it "return concated array" do
    #    all = subject.all
    #    expect(all.count).to be 200
    #    all.each do |rank|
    #      expect(rank).to be_an_instance_of Niconico::Video
    #      expect(rank.title).not_to be_nil
    #      expect(rank.id).not_to be_nil
    #    end
    #  end
    #end

    context "with using mock" do
      before do
        Agent.client.should_receive(:ranking).with("").and_return(["総合カテゴリランキング1位"])
        Agent.client.should_receive(:ranking).with("g_ent2").and_return(["音楽カテゴリランキング1位"])
      end

      it "return concated array" do
        expect(subject.all).to eq all_rank
      end
    end
  end

  describe "#filtered" do
    #context "with not using mock" do
    #  it "return array of hashes" do
    #    subject.filtered("music").each do |rank|
    #      expect(rank).to be_an_instance_of Hash
    #      expect(rank).not_to be_empty
    #    end
    #  end
    #end

    context "with using mock" do
      before do
        described_class.should_receive(:all).and_return(all_rank)
        described_class::Filter_Music.should_receive(:squeeze).with(all_rank)
      end

      context "with music" do
        it "call Filter_Music.squeeze dynamically" do
          expect {subject.filtered("music")}.not_to raise_error
        end
      end
    end
  end
end