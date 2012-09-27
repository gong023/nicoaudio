# -*- encoding: utf-8 -*-
require "#{Dir::pwd}/class/nicobase.rb"

class NicoRanking < NicoBase
  def initialize category
    initNico
    initMysql
    @run_st = initRunSetting category
  end

  def set
    check = @run_st[:regrep] 
    @run_st[:category] = "" if @run_st[:category].nil?
    all_rank = @nico.ranking(@run_st[:category])
    all_rank.each do |rank|
      if check =~ rank.title
        title = @mysql.escape(rank.title)
        insert = "INSERT IGNORE INTO #{@run_st[:table]} (video_id, title) VALUES ('#{rank.id}', '#{title}')" 
        @mysql.query(insert)
        pp "finished / #{rank.id}:#{rank.title}"
      end
    end
  end

  def get 
    today = Date::today.to_s
    FileUtils.mkdir_p("./video/#{@run_st[:dir]}/#{today}")
    ago = 1
    threads = []

    select = "SELECT * FROM #{@run_st[:table]} WHERE ctime > (NOW() - INTERVAL #{ago} DAY )"
    @mysql.query(select).each do |row|
      begin
        threads << Thread.new(row) do |thread|
          video = @nico.video("#{row["video_id"]}")
          open("./video/#{@run_st[:dir]}/#{today}/#{row["title"]}.mp4", "w"){|f| f.write video.get_video}
        end
      rescue
        Logger.new("./log/fail.log", 'weekly').debug("#{today}/#{row["title"]}")
        next 
      end
      #時間間隔開けないとニコ動から弾かれるようす
      sleep 20
    end

    threads.each {|t| t.join}
  end

  def initRunSetting category
    run_st = {
      'all'   => {
      :category => "",
      :regrep   => /歌ってみた|初音ミク|GUMI|巡音ルカ|KAITO|MEIKO|鏡音リン|鏡音レン|がくぽ/,
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
