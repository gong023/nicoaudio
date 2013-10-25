require 'systemu'
require "fileutils"

module NicoMedia
  class System
    autoload :S3,        "system/S3"
    autoload :File,      "system/file"
    autoload :Find,      "system/find"
    autoload :Ffmpeg,    "system/ffmpeg"
    autoload :Directory, "system/directory"

    VIDEO_ROOT = Setting.new.system["video"]["save"]
    AUDIO_ROOT = Setting.new.system["audio"]["save"]

    def self.execute cmd
      status, stdout, stderr = systemu cmd
      raise stderr unless status.success?
      stdout
    end
  end
end

