module NicoQuery

  def create_daily(table, video_id, title)
    "INSERT IGNORE INTO #{table} (video_id, title) VALUES ('#{video_id}', '#{title}')"
  end

  def find_by_interval(table, from_date, to_date)
    #CAUTION!! index type is range
    "SELECT * FROM daily_music WHERE ctime between '#{from_date}' AND '#{to_date}'"
  end

  def create_table
    "CREATE TABLE `daily_music` (
      `id` bigint(20) unsigned NOT NULL auto_increment,
      `video_id` varchar(30) NOT NULL,
      `title` varchar(255) NOT NULL,
      `ctime` timestamp NOT NULL default CURRENT_TIMESTAMP,
      PRIMARY KEY  (`id`),
      UNIQUE KEY `video_id` (`video_id`),
      KEY `video_id_index` (`video_id`),
      KEY `ctime_index` (`ctime`)
    ) ENGINE=InnoDB AUTO_INCREMENT=923 DEFAULT CHARSET=utf8"
  end

end
