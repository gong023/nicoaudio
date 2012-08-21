# -*- encoding: utf-8 -*-
#require 'mongo'
require 'niconico'
require 'mysql2'
require 'pp'
require 'date'
require 'fileutils'

require './nicosecret.rb'

class NicoRanking
    def initialize category
        secret_st = NicoSecret.new
        @nico = Niconico.new(secret_st.login_mail, secret_st.login_pass)
        @nico.login
        @mysql = Mysql2::Client.new(
            :host     => secret_st.mysql_host,
            :username => secret_st.mysql_user,
            :password => secret_st.mysql_pass,
            :database => 'nicoaudio'
        )
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
        ago = 1
        today = Date::today.to_s
        FileUtils.mkdir_p("./video/#{@run_st[:dir]}/#{today}")
        select = "SELECT * FROM #{@run_st[:table]} WHERE ctime > (NOW() - INTERVAL #{ago} DAY )"
        @mysql.query(select).each do |row|
            begin
                video = @nico.video("#{row["video_id"]}")
                open("./video/#{@run_st[:dir]}/#{today}/#{row["title"]}.mp4", "w"){|f| f.write video.get_video}
            rescue
                next 
            end
            #時間間隔開けないとニコ動から弾かれるようす
            sleep 20
        end
    end

    def initRunSetting category
        run_st = {
            'all'   => {
                :category => "",
                :regrep   => /歌ってみた|初音ミク|GUMI|巡音ルカ|KAITO|MEIKO|鏡音リン|鏡音レン|がくぽ/,
                :dir      => 'all',
                :table    => 'daily'
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

exit() unless $*[0] == '--type'
exit() unless $*[2] == '--category'
type = $*[1]
category = $*[3]
nico = NicoRanking.new(category)
if type == 'set'
    nico.set
else
    nico.get
end
p 'ok'
