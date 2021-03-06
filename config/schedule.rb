# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

job_type :bin,  "cd :path && :environment_variable=:environment :bundle_command bin/:task :output"

set :output, "log/cron_log.log"

# start the delayed_job daemon when the system reboots
every :reboot do
  bin "delayed_job start"
end

# restart the delayed_job daemon if it looks like it is not responding
every 4.minutes do
  runner "require 'delayed_job_util'; DelayedJobUtil.health_check"
end
