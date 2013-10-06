require 'systemu'

module NicoMedia
  class System
    VIDEO_ROOT = Setting.new.system["video"]["save"]
    AUDIO_ROOT = Setting.new.system["audio"]["save"]

    def self.execute cmd
      status, stdout, stderr = systemu cmd
      raise stderr if ! stderr.empty? || ! status.success?
      stdout
    end
  end
  require_relative "./system/file"
  require_relative "./system/directory"
  require_relative "./system/ffmpeg"
  require_relative "./system/find"
  require_relative "./system/S3"
end

