require "s3"

module NicoMedia
  class System
    class S3
      SETTING = Setting.system["S3"]
      @bucket = ::S3::Service.new(
          access_key_id: SETTING["access_key"],
          secret_access_key: SETTING["secret_key"]
      ).bucket(SETTING["bucket"])

      class << self
        def upload video_name
          obj = @bucket.objects.build("#{define_remote_path(video_name)}/#{video_name}")
          obj.content = open("#{System.define_local_path(video_name)}/#{video_name}")
          obj.content_type = define_content_type(video_name)
          obj.save
        end

        def exec video_id
          upload "#{video_id}.mp3"
          upload "#{video_id}.mp4"
        end

        def exist?(video_name)
          @bucket.object("#{define_remote_path(video_name)}/#{video_name}").exists?
        end

        def find_by_date(type, date)
          @bucket.objects.find_all(prefix: "#{type}/#{date}").map do |object|
            object.key.gsub(/#{type}\/#{date}\//, "").gsub(/#{System.extension(type)}/, "")
          end
        end

        private
        def define_remote_path video_name
          type == video_name.match(/.mp3$/) ? "audio" : "video"
          "#{type}/#{Record::Histry.instance.read_created_at(video_name)}"
        end

        def define_content_type video_name
          video_name.match(/.mp3$/) ? "audio/mpeg" : "video/mp4"
        end
      end
    end
  end
end
