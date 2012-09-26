#require 'mongo'
require 'niconico'
require 'mysql2'
require 'pp'
require 'date'
require 'fileutils'
require 'logger'
require 'benchmark'
require 'twitter'

require "#{Dir::pwd}/class/nicosecret.rb"

class NicoBase

  def initNico
    @nico = Niconico.new(LOGIN_MAIL, LOGIN_PASS)
    @nico.login
  end

  def initMysql
    @mysql = Mysql2::Client.new(
      :host     => MYSQL_HOST,
      :username => MYSQL_USER,
      :password => MYSQL_PASS,
      :database => 'nicoaudio'
    )
  end

  def initTwitter
    Twitter.configure do |config|
      config.consumer_key       = CONSUMER_KEY
      config.consumer_secret    = CONSUMER_SECRET
      config.oauth_token        = ACCESS_TOKEN
      config.oauth_token_secret = ACCESS_TOKEN_SECRET
    end
  end

end
