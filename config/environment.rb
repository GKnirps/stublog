# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Stublog::Application.initialize!

require 'rufus/scheduler'
#when running with passenger, restart rufus scheduler if needed
if defined?(PhusionPassenger) then
	PhusionPassenger.on_event :starting_worker_process do |forked|
		if forked then
			scheduler = Rufus::Scheduler.start_new
	
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
		end
	end
end
