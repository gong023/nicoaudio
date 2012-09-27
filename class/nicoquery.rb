module NicoQuery

  def create_daily(table, video_id, title)
    "INSERT IGNORE INTO #{table} (video_id, title) VALUES ('#{video_id}', '#{title}')"
  end

  def find_by_interval(table, from_date, to_date)
    #CAUTION!! index type is range
    "SELECT * FROM daily_music WHERE ctime between '#{from_date}' AND '#{to_date}'"
  end

end
