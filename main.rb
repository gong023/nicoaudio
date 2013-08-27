require "benchmark"
require_relative "./module/base.rb"

def main
  begin
#    bench = -> () do
    music_rank = Nico::Ranking.fetch_music
    Nico::Ranking.to_recoad(music_rank)
    Nico::Video.download_recently()
    Nico::Video.to_mp3
#    end
#    Report.new.success(&bench)
  rescue => e
    pp e.message
    pp e.backtrace
#    Report.new.fail(e)
  end
end

main()
