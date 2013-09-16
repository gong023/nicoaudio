require "twitter"

class Report
  class Twitt
    SETTING = Report::SETTING["twitter"]

    def initialize
      Twitter.configure do |config|
        config.consumer_key        = Twitt::SETTING["consumer_key"]
        config.consumer_secret     = Twitt::SETTING["consumer_secret"]
        config.oauth_token         = Twitt::SETTING["access_token"]
        config.oauth_token_secret  = Twitt::SETTING["access_secret"]
      end
    end

    def send_dm msg
      msg = msg.scan(/^.{130}/)[0]
      Twitter.direct_message_create(Twitt::SETTING["dm_screen"], msg)
    end
  end
end
