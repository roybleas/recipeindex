# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(name:  "Roy User",
             screen_name: "Roy",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)
             
99.times do |n|
  
  screen_name = Faker::Name.first_name
  name  = Faker::Name.name
  password = "password"
  User.create!(name:  name,
               screen_name: screen_name,
               password:              password,
               password_confirmation: password)
end
