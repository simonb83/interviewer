# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

every 1.day, at: '00:03 am' do
  runner "Campaign.close_deadline_past_campaigns"
  runner "Campaign.select_soon_to_close_campaigns"
end

# every 5.minutes do
#   runner "Admin.send_test_email"
# end
