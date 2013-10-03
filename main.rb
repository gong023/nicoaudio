require "./lib/base"

def main
  include NicoMedia
  begin
    NicoMedia::App::Ranking.reload
    NicoMedia::Report::Normal.execute[NicoMedia::App::Video.method(:download_recently)][NicoMedia::App::Video.method(:to_mp3)]
  rescue => e
    NicoMedia::Report::Abnormal.execute e
  ensure
    NicoMedia::System::Directory.create_video_by_date
    NicoMedia::System::Directory.create_audio_by_date
    record = NicoMedia::Record::History.new
    record.update_state(NicoMedia::System::Find.mp4_by_date, NicoMedia::Record::History::STATE_DOWNLOADED)
    record.update_state(NicoMedia::System::Find.mp3_by_date, NicoMedia::Record::History::STATE_CONVERTED)
  end
end

main()
