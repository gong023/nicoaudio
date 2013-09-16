class Report < Base
  SETTING = Setting.new.report
end

require_relative './report/twitter.rb'
require_relative './report/success.rb'
require_relative './report/fail.rb'
