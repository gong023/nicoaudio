require_relative "./module/base.rb"

def main
  begin
    fetch_music, to_record, download_recently, to_mp3 =
      Nico::Ranking.method(:fetch_music), Nico::Ranking.method(:to_record),
      Nico::Video.method(:download_recently), Nico::Video.method(:to_mp3)

    Report::Success.execute[fetch_music][to_record][download_recently][to_mp3]
  rescue => e
    Report::Fail.execute e
  end
end

main()
