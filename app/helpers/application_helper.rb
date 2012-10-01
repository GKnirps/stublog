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
end
