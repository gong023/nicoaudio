module NicoMedia
  class Report
    SETTING = Setting.new.report
  end
  require 'report/log'
  require 'report/twitter'
  require 'report/normal'
  require 'report/abnormal'
end
