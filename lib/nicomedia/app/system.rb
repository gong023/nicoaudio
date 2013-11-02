require 'systemu'
require "fileutils"

module NicoMedia
  class System
    autoload :S3,        "system/S3"
    autoload :File,      "system/file"
    autoload :Find,      "system/find"
    autoload :Ffmpeg,    "system/ffmpeg"
    autoload :Directory, "system/directory"

    VIDEO_ROOT = Setting.system["video"]["save"]
    AUDIO_ROOT = Setting.system["audio"]["save"]

    def self.execute cmd
      status, stdout, stderr = systemu cmd
      raise stderr unless status.success?
      stdout
    end

    def self.define_local_path video_name
      root = video_name.match(/.mp3$/) ? AUDIO_ROOT : VIDEO_ROOT
      path_date = Record::History.instance.read_created_at video_name.scan(/^.{2}\d+/)[0]
      "#{root}/#{path_date}"
    end

    def self.extension type
      type == "audio" ? ".mp3" : ".mp4"
    end
  end
end

