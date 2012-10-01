require "#{SCRIPT_ROOT}/class/nicobase.rb"

class NicoTweet < NicoBase
  def initialize
    initTwitter
  end

  def sendDM txt
    Twitter.direct_message_create(DM_SCREEN_NAME, txt)
  end
end
