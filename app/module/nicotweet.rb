class NicoBase
  def tweet skip
    Tweet.new skip
  end

  class Tweet < NicoBase
    def initialize skip
      @@skip = skip
      initTwitter
    end

    def sendDM txt
      return if @@skip == true
      Twitter.direct_message_create(DM_SCREEN_NAME, txt)
    end
  end
end
