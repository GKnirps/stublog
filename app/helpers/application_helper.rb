require 'rbbcode'
module ApplicationHelper
	#return full title based on page title and basic title
	def full_title(page_title)
		base_title = "Stranger Than Usual"
		if page_title.empty? then
			return base_title
		else
			return "#{base_title} - #{page_title}"
		end
	end

	#return nicely formatted date
	def format_date(date)
		return "#{date.mday}.#{date.mon}.#{date.year}  #{date.hour}:#{date.min}"
	end


	#default bbcode parser (I plan to extend this one)
	def bbparse(text)
		bbparser = RbbCode::Parser.new
		bbparser.parse(text).html_safe
	end
end
