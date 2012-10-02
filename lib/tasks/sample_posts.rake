namespace :db do
	desc "Fill database with sample posts"
	task populate_posts: :environment do
		users = User.where(author: true)
		23.times do
			caption = Faker::Lorem.sentence(3)
			content = Faker::Lorem.paragraph(6)
			users.each {|user| user.blogposts.create!(content: content, caption: caption)}
		end
	end


end
