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
	if User.count < 30
		30.times do |n|
		  
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
pubDish = Publication.find_or_create_by(title: "Dish")
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

catTypeI = Categorytype.find_or_create_by(code: 'I', name: 'Ingredient')
catTypeT = Categorytype.find_or_create_by(code: 'T', name: 'Style')
if Rails.env == "development"
	catTypeM = Categorytype.find_or_create_by(code: 'M', name: 'Meal')
end

descDel = pubDel.issuedescriptions.find_by_title('Feb')
[{:yr => 2007, :no => 57},{:yr => 2008, :no => 68},{:yr => 2006, :no => 46}].each do |issue|
 	IssueyearGenerator.new(pubDel, issue[:yr]).gen_issues_by_number(issue[:no]) unless descDel.issues.exists?(year: issue[:yr]) 
	mag_title = "del"
	RecipeImporter.new(pubDel,issue[:yr],mag_title).load_recipes_by_year unless pubDel.recipes.where('year = ?',issue[:yr]).count > 0
	CategoryImporter.new(issue[:yr],mag_title).load_categories
	RecipeImporter.new(pubDel,issue[:yr],mag_title).loadRecipesByCategory
end	

descDish = pubDish.issuedescriptions.find_by_title('Feb-Mar')
[{:yr => 2010, :no => 28, :noRange => '28-33'}].each do |issue|
 	IssueyearGenerator.new(pubDish, issue[:yr]).gen_issues_by_number(issue[:no]) unless descDish.issues.exists?(year: issue[:yr]) 
	mag_title = "dish"
	RecipeImporter.new(pubDish,issue[:noRange],mag_title).load_recipes_by_issue
	CategoryImporter.new(issue[:noRange],mag_title).load_categories
	RecipeImporter.new(pubDish,issue[:noRange],mag_title).loadRecipesByCategory
end	






