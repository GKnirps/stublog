atom_feed language: 'de_DE' do |feed|
	feed.title @title
	feed.updated @updated

	@blogposts.each do |blogpost|
		feed.entry(blogpost) do |entry|
			entry.url blogpost_url(blogpost)
			entry.title blogpost.caption

			entry.content bbparse(blogpost.content, :not_safe), type: 'html'
			entry.updated blogpost.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")

			entry.author do |author|
				author.name blogpost.user.name
			end
		end
	end
end
