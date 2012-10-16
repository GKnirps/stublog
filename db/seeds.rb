# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#new admin user
admin = User.create!(	name: "Admin",
			email: "admin@strangerthanusual.de",
			password: "foobar",
			password_confirmation: "foobar")
admin.toggle!(:admin)
#new author user
author = User.create!(	name: "Author1",
			email: "author1@strangerthanusual.de",
			password: "foobar",
			password_confirmation: "foobar")
author.toggle!(:author)
author = User.create!(	name: "Author2",
			email: "author2@strangerthanusual.de",
			password: "foobar",
			password_confirmation: "foobar")
author.toggle!(:author)
puts "Admin and authors created"
#create 42 sample users
20.times do |n|
	name = Faker::Name.name
	email = "example-#{n+1}@strangerthanusual.de"
	password = "password"
	User.create!(	name: name,
			email: email,
			password: password,
			password_confirmation: password)
end
puts "Sample users created"

#add sample categories
6.times do |n|
	Category.create!( name: "Cat #{n}", description: Faker::Lorem.sentence(8) )
end

categories = Category.all
puts "Sample categories created"

#add sample posts with tags
#sample tags
tags = Faker::Lorem.words(10)
#create sample posts
users = User.where(author: true)
23.times do
	caption = Faker::Lorem.sentence(3)
	content = Faker::Lorem.paragraph(6)
	users.each do |user|
		p = user.blogposts.create!(content: content, caption: caption, category_id: categories.sample.id)
		taglist = tags.sample(3).join(",")
		p.add_taglist! taglist
	end
end
puts "Sample posts created"

#add sample comments
users = User.all
Blogpost.all.each do |blogpost|
	#comment without caption
	p = blogpost.comments.new(content: Faker::Lorem.paragraph(3))
	p.author = users.sample
	p.save!
	p.reload
	pc = p.comments.new(content: Faker::Lorem.paragraph(2))
	pc.author = users.sample
	pc.save!
	#Comment with caption
	p = blogpost.comments.new(caption: Faker::Lorem.sentence(3), content: Faker::Lorem.paragraph(4))
	p.author = users.sample
	p.save!
end
puts "Sample comments created"

#add sample quotes
41.times do | n| 
	q = QuoteOfTheDay.new(content: Faker::Lorem.sentence(5), published: false)
	q.created_at = n.days.ago
	q.save!
end
q = QuoteOfTheDay.new(content: "The best quote ever", published: true)
q.created_at = 42.days.ago
q.save

puts "Sample quotes created"
