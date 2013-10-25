require "s3"

module NicoMedia
  class System
    class S3
      SETTING = Setting.new.system["S3"]
      @bucket = ::S3::Service.new(
          access_key_id: SETTING["access_key"],
          secret_access_key: SETTING["secret_key"]
      ).bucket(SETTING["bucket"])

      class << self
        def upload video_id
          local_path = video_id.match(/.mp3$/) ? AUDIO_ROOT : VIDEO_ROOT
          type = video_id.match(/.mp3$/) ? "audio" : "video"
          path_date = Record::History.instance.read_created_at video_id.scan(/^.{2}\d+/)[0]
          obj = @bucket.objects.build("#{type}/#{path_date}/#{video_id}")
          obj.content = open("#{local_path}/#{path_date}/#{video_id}")
          obj.save
        end

        def exec video_id
          upload "#{video_id}.mp3"
          upload "#{video_id}.mp4"
        end

        def exist?(type, video_id)
          path_date = Record::History.instance.read_created_at video_id
          extension = type == "audio" ? ".mp3" : ".mp4"
          @bucket.object("#{type}/#{path_date}/#{video_id}#{extension}").exists?
        end

        def find_by_date(type, date)
          extension = type == "audio" ? ".mp3" : ".mp4"
          @bucket.objects.find_all(prefix: "#{type}/#{date}").map do |object|
            object.key.gsub(/#{type}\/#{date}\//, "").gsub(/#{extension}/, "")
          end
        end
      end
    end
  end
end
