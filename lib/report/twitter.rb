require "twitter"
module NicoMedia
  class Report
    class Twitter
      SETTING = NicoMedia::Report::SETTING["twitter"]

      def initialize
        Twitter.configure do |config|
          config.consumer_key        = SETTING["consumer_key"]
          config.consumer_secret     = SETTING["consumer_secret"]
          config.oauth_token         = SETTING["access_token"]
          config.oauth_token_secret  = SETTING["access_secret"]
        end
      end

      def send_dm msg
        pp msg; return if SETTING["skip"]
        msg = "#{msg + SETTING["env"]}/".scan(/^.{130}/)[0]
        Twitter.direct_message_create(SETTING["dm_screen"], msg)
      end
    end
  end
end
