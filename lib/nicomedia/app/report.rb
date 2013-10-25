module NicoMedia
  class Report
    autoload :Log,      'report/log'
    autoload :Twitter,  'report/twitter'
    autoload :Normal,   'report/normal'
    autoload :Abnormal, 'report/abnormal'

    SETTING = Setting.new.report
  end
end
