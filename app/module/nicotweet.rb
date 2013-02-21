require "#{SCRIPT_ROOT}/app/nicobase.rb"

class NicoTweet < NicoBase
  def initialize tweet
    @@tweet = tweet
    initTwitter
  end

  def sendDM txt
    return if @@tweet == false
    Twitter.direct_message_create(DM_SCREEN_NAME, txt)
  end
end
