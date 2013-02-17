module NicoQuery

  def create_daily table, video_id, title
    "INSERT IGNORE INTO #{table} (video_id, title) VALUES ('#{video_id}', '#{title}')"
  end

  def find_enable_by_interval from_date, to_date
    #range
    "SELECT * FROM daily_music WHERE ctime between '#{from_date}' AND '#{to_date}' AND state = 0"
  end

  def find_by_interval from_date, to_date
    #range
    "SELECT * FROM daily_music WHERE ctime between '#{from_date}' AND '#{to_date}'"
  end

  def find_by_videoid video_id
    #range
    "SELECT * FROM daily_music WHERE video_id = '#{video_id}'"
  end

  def update_video_state state, video_id
    "UPDATE daily_music SET state = #{state} WHERE video_id = '#{video_id}'"
  end

  def create_table 
    "CREATE TABLE `daily_music` (
      `id` bigint(20) unsigned NOT NULL auto_increment,
      `video_id` varchar(30) NOT NULL,
      `title` varchar(255) NOT NULL,
      `ctime` timestamp NOT NULL default CURRENT_TIMESTAMP,
      `state` tinyint(1) NOT NULL default '0',
      PRIMARY KEY  (`id`),
      UNIQUE KEY `video_id` (`video_id`),
      KEY `ctime_state_idx` (`ctime`,`state`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8"
  end

end
