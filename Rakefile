require 'rspec/core/rake_task'
task default: :spec

RSpec::Core::RakeTask.new("spec")

def load
  $:.concat Dir.glob("lib/**/")
  require "nicomedia"
  include NicoMedia
end

task :hourly do
  load
  Task::Hourly.get_step_by_step
end

task :daily do
  load
  uploaded = Record::History.instance.read_recently(:uploaded).to_a.count
  converted = Record::History.instance.read_recently(:converted).to_a.count
  registerd = Record::History.instance.read_recently(:registerd).to_a.count
  Report::Twitter.new.send_dm "[24hours report] uploaded:#{uploaded} / converted:#{converted} / registerd:#{registerd}"
end

task :dump do
  load
  Task::Dump.new.all_by_rand
end

