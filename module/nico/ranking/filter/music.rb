class Filter
  class Music
    REGREP = /歌ってみた|弾いてみた|初音ミク|GUMI|巡音ルカ|KAITO|MEIKO|鏡音リン|鏡音レン|がくぽ|IA|演奏|音MAD/
    ABORT_REGREP = /実況/

    def self.execute(ranks)
      Filter.execute(ranks, REGREP, ABORT_REGREP)
    end
  end
end
