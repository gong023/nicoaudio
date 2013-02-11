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

  def get duration = nil
    if duration.nil?
        to_date = Time.now.strftime("%Y-%m-%d %H:%M:%S")
        from_date = ((Date.today) - 1).to_s
      else
        duration = duration.sub(/~/, '')
        to_date = duration.sub(/^[0-9]{4}?-[0-9]{2}?-[0-9]{2}/, '');
        from_date = duration.sub(/[0-9]{4}?-[0-9]{2}?-[0-9]{2}$/, '');
    end

    threads = []

    select = find_enable_by_interval(from_date, to_date)
    @mysql.query(select).each do |row|
      dir_date = row['ctime'].to_s.match(/^[0-9]{4}?-[0-9]{2}?-[0-9]{2}/).to_s
      FileUtils.mkdir_p("./video/#{@run_st[:dir]}/#{dir_date}")
      begin
        threads << Thread.new(row) do |thread|
          video = @nico.video("#{row["video_id"]}")
          open("./video/#{@run_st[:dir]}/#{dir_date}/#{row["video_id"]}.mp4", "w"){|f| f.write video.get_video}
        end
      rescue
        Logger.new("./log/fail.log", 'weekly').debug("#{dir_date}/#{row["title"]}")
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
      :regrep   => /歌ってみた|初音ミク|GUMI|巡音ルカ|KAITO|MEIKO|鏡音リン|鏡音レン|がくぽ|IA|MAD/,
      :dir      => 'all',
      :table    => 'daily_music'
      },
      'music' => {
      :category => 'g_ent2',
      :regrep   => /歌ってみた|初音ミク|GUMI|巡音ルカ|KAITO|MEIKO|鏡音リン|鏡音レン|がくぽ|IA|演奏/,
      :dir      => 'music',
      :table    => 'daily_music'
      }
    }
    run_st[category]
  end
end
