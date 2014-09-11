require 'rufus/scheduler'

scheduler = Rufus::Scheduler.new

if Rails.env.development? then
	schedule = '* * * * *'
else
	schedule = '0 0 * * *'
end
scheduler.cron schedule do
	if QuoteOfTheDay.publish? then
		QuoteOfTheDay.publish_next!
	end
end
