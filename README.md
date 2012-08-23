#これは何  
* nicoranking.rb -> ニコニコ動画のランキングから動画をDLします
* convertmp4.sh  -> DLしたmp4をmp3に変換します 

#準備するもの
*1.nicosecret.rb *
パスワードなどを記述したrubyファイルをnicoranking.rbと同じディレクトリに置いてください
>"
#ニコニコ動画のアカウント

LOGIN_MAIL = 'youremail@email.com'

LOGIN_PASS = 'your_password'

#MySQLを使うのでその設定

MYSQL_HOST = 'localhost'

MYSQL_USER = 'root'

MYSQL_PASS = 'mysql_passwd'"

##2.logディレクトリ
スクリプトのベンチマークをlogにとるのでディレクトリを予め用意しておいてください  
こんなかんじで
>"
|-- log
|   |-- get
|   |   `-- benchmark.log
|   `-- set
|       `-- benchmark.log
|-- convertmp4.sh
|-- nicoranking.rb
|-- nicosecret.rb
"
##3.Mysqlのテーブル
ＤＬするものが一意であることを保証したかったのでDBを使っています。  
定義はこんな感じです（けっこうてきとう）
>"
CREATE TABLE `daily` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `video_id` varchar(30) NOT NULL,
  `title` varchar(255) NOT NULL,
  `ctime` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `video_id` (`video_id`),
  KEY `video_id_index` (`video_id`),
  KEY `ctime_index` (`ctime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
"

#オプション説明
* nicoranking.rb
    * --type setでニコ動のランキング「歌ってみた」等の単語を含む動画を見つけてDBに入れる
    * --type getでDBから直近一日の動画を選んでmp4でダウンロードする
    * --category allとすると総合ランキングを対象とする
    * --category musicとすると音楽カテゴリのランキングを対象とする
