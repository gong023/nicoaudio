# -*- encoding: utf-8 -*-
#require 'mongo'
require 'niconico'
require 'mysql2'
require 'pp'
require 'date'
require 'fileutils'

class NicoRanking
    def initialize category
        @nico = Niconico.new('geekmaru@gmail.com', 'koenji81')
        @nico.login
        @mysql = Mysql2::Client.new(
            :host     => 'localhost',
            :username => 'root',
            :password => 'mylocal',
            :database => 'nicoaudio'
        )
        @st = getStatus category
    end

    def set
        check = @st[:regrep] 
        @st[:category] = "" if @st[:category].nil?
        all_rank = @nico.ranking(@st[:category])
        all_rank.each do |r|
            if check =~ r.title
                title = @mysql.escape(r.title)
                insert = "INSERT IGNORE INTO #{@st[:table]} (video_id, title) VALUES ('#{r.id}', '#{title}')" 
                @mysql.query(insert)
                pp "finished / #{r.id}:#{r.title}"
            end
        end
    end

    def get 
        ago = 1
        today = Date::today.to_s
        FileUtils.mkdir_p("./video/#{@st[:dir]}/#{today}")
        select = "SELECT * FROM #{@st[:table]} WHERE ctime > (NOW() - INTERVAL #{ago} DAY )"
        @mysql.query(select).each do |row|
            begin
                video = @nico.video("#{row["video_id"]}")
                open("./video/#{@st[:dir]}/#{today}/#{row["title"]}.mp4", "w"){|f| f.write video.get_video}
            rescue
                next 
            end
            #時間間隔開けないとニコ動から弾かれるようす
            sleep 120 
        end
    end

    def getStatus category
        status_map = {
            'all'   => {
                :category => "",
                :regrep   => /歌ってみた|初音ミク|GUMI|巡音ルカ|KAITO|MEIKO|鏡音リン|鏡音レン/,
                :dir      => 'all',
                :table    => 'daily'
            },
            'music' => {
                :category => 'g_ent2',
                :regrep   => //,
                :dir      => 'music',
                :table    => 'daily_music'
            }
        }
        status_map[category]
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
