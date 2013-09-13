require 'systemu'

class NicoSystem < Base
  VIDEO_ROOT = Setting.new.load["system"]["video"]["save"]
  AUDIO_ROOT = Setting.new.load["system"]["audio"]["save"]

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
