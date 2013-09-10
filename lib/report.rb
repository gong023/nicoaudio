class Report < Base
  SETTING = Setting.new.load["report"]
end

require_relative './report/twitter.rb'
require_relative './report/success.rb'
require_relative './report/fail.rb'
