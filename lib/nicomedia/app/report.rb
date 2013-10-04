module NicoMedia
  class Report
    SETTING = Setting.new.report
  end
  require_relative './report/log'
  require_relative './report/twitter'
  require_relative './report/normal'
  require_relative './report/abnormal'
end
