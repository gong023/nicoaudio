require "twitter"
module NicoMedia
  class Report
    class Twitt
      SETTING = SETTING["twitter"]

      def initialize
        Twitter.configure do |config|
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
        msg = "#{SETTING["env"] + " " + msg.to_s}".scan(/^.{0,130}/)[0]
        Twitter.direct_message_create(SETTING["dm_screen"], msg)
      end
    end
  end
end
