require 'systemu'

class System < Base
  VIDEO_ROOT = Base.load_setting["system"]["video"]["save"]
  AUDIO_ROOT = Base.load_setting["system"]["audio"]["save"]

  def self.execute cmd
    status, stdout, stderr = systemu cmd
    raise stderr if ! stderr.empty? || ! status.success?
    stdout
  end
end

require_relative "./system/file.rb"
require_relative "./system/directory.rb"
require_relative "./system/ffmpeg.rb"
require_relative "./system/find.rb"
