namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do # makes sure the Rake task has access to the
									# rails environment		
		make_users
		make_microposts
		make_relationships
	end
end
		
def make_users
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
end

def make_microposts
	users = User.all(limit: 6)
	50.times do
		content = Faker::Lorem.sentence(5)
		users.each { |user| user.microposts.create!(content: content) }
	end
end

def make_relationships
	users = User.all
	user = users.first
	followed_users 	= users[2..50]
	followers		= users[3..40]
	followed_users.each { |followed| user.follow!(followed) }
	followers.each 		{ |follower| follower.follow!(user) }
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