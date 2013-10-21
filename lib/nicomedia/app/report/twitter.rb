require "twitter"
module NicoMedia
  class Report
    class Twitter
      SETTING = SETTING["twitter"]

      def initialize
        ::Twitter.configure do |config|
          config.consumer_key        = SETTING["consumer_key"]
          config.consumer_secret     = SETTING["consumer_secret"]
          config.oauth_token         = SETTING["access_token"]
          config.oauth_token_secret  = SETTING["access_secret"]
        end
      end

      def send_dm msg
        if SETTING["skip"]
          pp msg
          return
        end
        msg = optimaze("[#{SETTING["env"]}]  #{msg.to_s}")
        begin
          ::Twitter.direct_message_create(SETTING["dm_screen"], msg)
        rescue ::Twitter::Error::Forbidden
          Log.write("twitter_forbidden", msg, "fail")
        end
      end

      def optimaze msg
        msg.encode("UTF-16BE",
                   invalid: :replace,
                   undef: :replace,
                   replace: '?').encode("UTF-8").scan(/^.{0,130}/)[0]
      end

    end
  end
end
