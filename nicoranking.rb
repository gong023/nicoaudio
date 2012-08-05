# -*- encoding: utf-8 -*-
require 'niconico'
#require 'mongo'
require 'pp'
require 'mysql2'

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
        select = "SELECT * FROM daily WHERE ctime > (NOW() - INTERVAL #{ago} DAY )"
        @mysql.query(select).each do |row|
            video = @nico.video("#{row["video_id"]}")
            open("./video/#{row["title"]}.mp4", "w"){|f| f.write video.get_video}
            sleep 120 #感覚開けないと弾かれる
        end
    end
end

exit() unless $*[0] == '--type'
nico = NicoRanking.new
if $*[1] == 'set'
    nico.set
else
    nico.get
end
p 'ok'
