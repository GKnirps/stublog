namespace :db do
	desc "Fill database with sample users"
	task populate_user: :environment do
		#new admin user
		admin = User.create!(	name: "Admin",
					email: "admin@strangerthanusual.de",
					password: "foobar",
					password_confirmation: "foobar")
		admin.toggle!(:admin)
		#new author user
		author = User.create!(	name: "Author",
					email: "author@strangerthanusual.de",
					password: "foobar",
					password_confirmation: "foobar")
		author.toggle!(:author)

		#create 42 sample users
		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@strangerthanusual.de"
			password = "password"
			User.create!(	name: name,
					email: email,
					password: password,
					password_confirmation: password)
		end
	end
end
