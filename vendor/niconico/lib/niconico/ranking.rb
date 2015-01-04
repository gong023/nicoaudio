# -*- coding: utf-8 -*-

class Niconico
  # options[:span]    -> :hourly, :daily, :weekly, :monthly, :total
  #                or -> :hour, :day, :week, :month, :all
  #   default: daily
  #
  # options[:method] -> :fav,     :view, :comment, :mylist
  #                     (or :all)        (or :res)
  def ranking(category, options={})
    login unless @logined

    span = options[:span] || :daily
    span = :hourly  if span == :hour
    span = :daily   if span == :day
    span = :weekly  if span == :week
    span = :monthly if span == :month
    span = :total   if span == :all

    method = options[:method] || :fav
    method = :res if method == :comment
    method = :fav if method == :all

    page = @agent.get(url = "http://www.nicovideo.jp/ranking/#{method}/#{span}/#{category}")
    kuso_arr = []
    page.search("p.itemTitle.ranking").each do |link|
      link.children.search("a").each do |elem|
        matches = elem.attributes["href"].value.match(/(?<category>^.*?watch\/)(?<video_id>[a-z]+\d+)/)
        kuso_arr << Video.new(self, matches["video_id"], title: elem.attributes["title"].value)
      end
    end
    kuso_arr
  end
end
