module NicoMedia
  class Report
    autoload :Log,      'report/log'
    autoload :Twitter,  'report/twitt'
    autoload :Normal,   'report/normal'
    autoload :Abnormal, 'report/abnormal'

    SETTING = Setting.new.report
  end
end
