# -*- encoding: utf-8 -*-
require "#{SCRIPT_ROOT}/class/nicobase.rb"

class NicoRanking < NicoBase
  include NicoQuery

  def initialize category
    @nico = initNico
    @nico.login
    @mysql  = initMysql
    @run_st = initRunSetting category
  end

  def set
    check = @run_st[:regrep] 
    @run_st[:category] = "" if @run_st[:category].nil?
    all_rank = @nico.ranking(@run_st[:category])
    all_rank.each do |rank|
      if check =~ rank.title
        title = @mysql.escape(rank.title)
        @mysql.query(create_daily(@run_st[:table], rank.id, title))
        pp "finished / #{rank.id}:#{rank.title}"
      end
    end
  end

  def get 
    ago = 1
    today     = Date::today
    from_date = today - ago
    FileUtils.mkdir_p("./video/#{@run_st[:dir]}/#{today}")
    threads = []

    select = find_by_interval(@run_st[:table], from_date.to_s, today.to_s)
    @mysql.query(select).each do |row|
      begin
        threads << Thread.new(row) do |thread|
          video = @nico.video("#{row["video_id"]}")
          open("./video/#{@run_st[:dir]}/#{today}/#{row["video_id"]}.mp4", "w"){|f| f.write video.get_video}
        end
      rescue
        Logger.new("./log/fail.log", 'weekly').debug("#{today}/#{row["title"]}")
        next 
      end
      #時間間隔開けないとニコ動から弾かれるようす
      sleep 2
    end

    threads.each {|t| t.join}
  end

  def initRunSetting category
    run_st = {
      'all'   => {
      :category => "",
      :regrep   => /歌ってみた|初音ミク|GUMI|巡音ルカ|KAITO|MEIKO|鏡音リン|鏡音レン|がくぽ|MAD/,
      :dir      => 'all',
      :table    => 'daily_music'
    },
      'music' => {
      :category => 'g_ent2',
      :regrep   => /歌ってみた|初音ミク|GUMI|巡音ルカ|KAITO|MEIKO|鏡音リン|鏡音レン|がくぽ|演奏/,
      :dir      => 'music',
      :table    => 'daily_music'
    }
    }
    run_st[category]
  end
end
