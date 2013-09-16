require_relative "./lib/base.rb"

def main
  begin
    Nico::Ranking.reload
    Report::Success.execute[Nico::Video.method(:download_recently)][Nico::Video.method(:to_mp3)]
  rescue => e
    NicoSystem::Directory.create_video_by_date
    NicoSystem::Directory.create_audio_by_date
    record = Record::History.new
    record.update_state(NicoSystem::Find.mp4_by_date, Record::History::STATE_DOWNLOADED)
    record.update_state(NicoSystem::Find.mp3_by_date, Record::History::STATE_CONVERTED)

    Report::Fail.execute e
  end
end

main()
