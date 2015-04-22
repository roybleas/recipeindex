# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

load(Rails.root.join( 'db', 'seeds', 'seedhelpers.rb'))

User.create(name:  "Roy Admin User",
             screen_name: "Admin Roy",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)
User.create(name:  "Roy User",
             screen_name: "Roy",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: false)

if Rails.env == "development"
	#create some extra users to play with during development
	if User.count < 99
		99.times do |n|
		  
		  screen_name = Faker::Name.first_name
		  name  = Faker::Name.name
		  password = "password"
		  User.create(name:  name,
		               screen_name: screen_name,
		               password:              password,
		               password_confirmation: password)
		end
	end
end

pubDel = Publication.find_or_create_by(title: "Delicious")
	pubDel.published = "Monthly"
	pubDel.description = "ABC food magazine"
	pubDel.save
pubDish = Publication.find_or_create_by!(title: "Dish")
	pubDish.published = "Bimonthly"
	pubDish.description = "New Zealand magazine published by Tangible Media"
	pubDish.save
	
if Rails.env == "development"
	# create an extra publication without indexes for development testing
	pubMast = Publication.find_or_create_by(title: "Masterchef", published: "Monthly", description: "TV show themed magazine ceased publication in 2012")
end

unless pubDel.issuedescriptions.exists?(title: 'Feb') then
	id = IssuedescriptionsGenerator.new(pubDel)
	id.gen_monthly(excludeJan = true)
end
unless pubDish.issuedescriptions.exists?(title: 'Feb-Mar') then
	id = IssuedescriptionsGenerator.new(pubDish)
	id.gen_bimonthly(excludeJan = true)
end

descDel = pubDel.issuedescriptions.find_by_title('Feb')
[{:yr => 2007, :no => 57},{:yr => 2008, :no => 68},{:yr => 2009, :no => 79}].each do |issue|
 	IssueyearGenerator.new(pubDel, issue[:yr]).gen_issues_by_number(issue[:no]) unless descDel.issues.exists?(year: issue[:yr]) 
end	

descDish = pubDish.issuedescriptions.find_by_title('Feb-Mar')
[{:yr => 2004, :no => 1},{:yr => 2012, :no => 40},{:yr => 2010, :no => 28}].each do |issue|
 	IssueyearGenerator.new(pubDish, issue[:yr]).gen_issues_by_number(issue[:no]) unless descDish.issues.exists?(year: issue[:yr]) 
end	

	




