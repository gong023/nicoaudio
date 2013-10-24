require 'systemu'
require "fileutils"

module NicoMedia
  class System
    VIDEO_ROOT = Setting.new.system["video"]["save"]
    AUDIO_ROOT = Setting.new.system["audio"]["save"]

    def self.execute cmd
      status, stdout, stderr = systemu cmd
      raise stderr unless status.success?
      stdout
    end
  end
  require "system/file"
  require "system/directory"
  require "system/ffmpeg"
  require "system/find"
  require "system/S3"
end

