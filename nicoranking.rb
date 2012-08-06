# -*- encoding: utf-8 -*-
#require 'mongo'
require 'niconico'
require 'mysql2'
require 'pp'
require 'date'
require 'fileutils'

class NicoRanking
    def initialize
        @nico = Niconico.new('geekmaru@gmail.com', 'koenji81')
        @nico.login
        @mysql = Mysql2::Client.new(
            :host     => 'localhost',
            :username => 'root',
            :password => 'mylocal',
            :database => 'nicoaudio'
        )
    end

    def set
        check = /歌ってみた|初音ミク|GUMI|巡音ルカ|KAITO|MEIKO|鏡音リン|鏡音レン/
        all_rank = @nico.ranking("")
        all_rank.each do |r|
            if check =~ r.title
                title = @mysql.escape(r.title)
                insert = "INSERT IGNORE INTO daily (video_id, title) VALUES ('#{r.id}', '#{title}')" 
                @mysql.query(insert)
                pp "finished / #{r.id}:#{r.title}"
            end
        end
    end

    def get 
        ago = 1
        today = Date::today.to_s
        FileUtils.mkdir_p("./video/#{today}")
        select = "SELECT * FROM daily WHERE ctime > (NOW() - INTERVAL #{ago} DAY )"
        @mysql.query(select).each do |row|
            video = @nico.video("#{row["video_id"]}")
            open("./video/#{today}/#{row["title"]}.mp4", "w"){|f| f.write video.get_video}
            sleep 120 #時間間隔開けないとニコ動から弾かれるようす
        end
    end
end

exit() unless $*[0] == '--type'
nico = NicoRanking.new
type = $*[1]
if type == 'set'
    nico.set
else
    nico.get
end
p 'ok'
