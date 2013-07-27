namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do # makes sure the Rake task has access to the
									# rails environment
		admin = User.create!(name: "Sophia Davis",
					email: "example@example.su",
					password: "password",		
					password_confirmation: "password")
		admin.toggle!(:admin)
		99.times do |x|
			name = Faker::Name.name
			email = "example-#{x+1}@example.su"
			password = "password"
			User.create!(name: name,
						email: email,
						password: password,		
						password_confirmation: password)
		end
		users = User.all(limit: 6)
		50.times do
			content = Faker::Lorem.sentence(5)
			users.each { |user| user.microposts.create!(content: content) }
		end
	end
end

=begin
bundle exec rake db:reset
bundle exec rake db:populate
bundle exec rake db:test:prepare

and remember to restart server

$ heroku pg:reset DATABASE_URL --confirm <name-heroku-gave-to-your-app>
$ heroku run rake db:migrate
$ heroku run rake db:populate

=end