require "s3"
module NicoMedia
  class System
    class S3
      SETTING = Setting.new.system["S3"]
      @service = ::S3::Service.new(
          access_key_id: SETTING["access_key"],
          secret_access_key: SETTING["secret_key"]
      )
      class << self
        def upload video_id
          local_path = video_id.match(/.mp3$/) ? AUDIO_ROOT : VIDEO_ROOT
          type = video_id.match(/.mp3$/) ? "audio" : "video"
          path_date = Record::History.new.read_created_at video_id.scan(/^.{2}\d+/)[0]
          obj = @service.bucket(SETTING["bucket"]).objects.build("#{type}/#{path_date}/#{video_id}")
          obj.content = open("#{local_path}/#{path_date}/#{video_id}")
          obj.save
        end

        def upload_multi video_id
          upload "#{video_id}.mp3"
          upload "#{video_id}.mp4"
        end

        def exists?(type, video_id)
          path_date = Record::History.new.read_created_at video_id
          extension = type == "audio" ? ".mp3" : ".mp4"
          begin
            @service.buckets.find(SETTING["bucket"]).objects.find("#{type}/#{path_date}/#{video_id}/#{extension}")
          rescue ::S3::Error::NoSuchKey
            return false
          end
          return true
        end
      end
    end
  end
end
