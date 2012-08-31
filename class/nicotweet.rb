require "#{Dir::pwd}/class/nicobase.rb"

class NicoTweet < NicoBase
  def initialize
    Twitter.configure do |config|
      config.consumer_key       = CONSUMER_KEY
      config.consumer_secret    = CONSUMER_SECRET
      config.oauth_token        = ACCESS_TOKEN
      config.oauth_token_secret = ACCESS_TOKEN_SECRET
    end
  end

  def sendDM txt
    Twitter.direct_message_create(DM_SCREEN_NAME, txt)
  end
end
