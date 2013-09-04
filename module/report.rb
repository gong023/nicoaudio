class Report < Base
  SETTING = Base.load_setting["report"]
end

require_relative './report/twitter.rb'
require_relative './report/success.rb'
require_relative './report/fail.rb'
