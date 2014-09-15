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
		return date.strftime "%d.%m.%Y %H:%M"
	end
  
  def html_whitelist(html)
    html = Sanitize.fragment(html,
      elements: ['a', 'ol', 'ul', 'li', 'br', 'p', 'div', 'strong', 'em', 'table', 'th', 'tr', 'h3', 'h4', 'h5', 'img', 'blockquote'],
      attributes: {
        'img' => ['src', 'alt', 'title'],
        'a' => ['href'],
        'table' => ['border'],
        'blockquote' => ['cite']
      },
      protocols: {
        'a' => {'href' => ['http', 'https', 'mailto']},
        'img' => {'img' => ['http', 'https']}
      }
    )
    html.html_safe
  end
end
