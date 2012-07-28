# -*- encoding: utf-8 -*-
require 'niconico'
require 'mongo'
require 'pp'

class NicoRanking
    def initialize
        @nico = Niconico.new('geekmaru@gmail.com', 'koenji81')
        @nico.login

        @mongo = Mongo::Connection.new('localhost', 27017)
    end

    def filterRank 
        check = /歌ってみた|初音ミク|GUMI|巡音ルカ/
        mongo_db = @mongo.db('nicosound')
        all_rank = @nico.ranking("")
        @ranking = []
        all_rank.each do |r|
            if check =~ r.title
                @ranking.push("#{r.id}" => "#{r.title}")
                data = ["#{r.id}" => ["id" => "#{r.id}","title" => "#{r.title}","ctime" => "#{Time.now}"]]
        pp data 
                mongo_db['ranking'].insert(data)
                mongo_db['ranking'].ensure_index("#{r.id}")
            end
        end
    end

    def insert
        mongo_db = @mongo.db('nicosound')
        pp mongo_db['ranking'].find()
    end

    def getFlv
        return nil if @ranking.nil?
        @ranking.each do |id, title|
            $stdout = open("open.flv", "w")
            puts @nico.video("#{id}").get_video
            $stdout.flush
            break
        end
    end
end

nico = NicoRanking.new
nico.filterRank
p 'ok'
