require "/var/www/scripts/nicoaudio/class/nicobase.rb"

class NicoTestMechanize < NicoBase
  def initialize
    @nico = initNico
    @nico.login
  end

  def get video_id
    agent = @nico.video(video_id)
    agent.get
    open("./hoge.mp4", "w") {|f|
      f.write(agent.get_video)
    }
  end
end

video_id = 'sm20097220'
NicoTestMechanize.new.get(video_id)
