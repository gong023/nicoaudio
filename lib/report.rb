module NicoMedia
  class Report
    SETTING = NicoMedia::Setting.new.report
  end
  require_relative './report/log'
  require_relative './report/twitter'
  require_relative './report/success'
  require_relative './report/fail'
end
