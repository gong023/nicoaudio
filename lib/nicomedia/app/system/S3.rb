require "aws-sdk"
module NicoMedia
  class System
    class S3
      SETTING = Setting.new.system["S3"]
      def initialize
        @service = ::AWS::S3::new(
            access_key_id: SETTING["access_key"],
            secret_access_key: SETTING["secret_key"]
        )
      end

      def upload(type, path, name)
        obj = @service.buckets[SETTING["bucket"]].objects["#{type}/#{name}"]
        obj.write(Pathname.new("#{path}/#{name}"))
        # open.(path_name)でもいけてほしい
      end

      def find(path, name)
      end
    end
  end
end