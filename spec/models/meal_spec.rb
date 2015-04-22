# == Schema Information
#
# Table name: meals
#
#  id          :integer          not null, primary key
#  description :string(255)
#  seq         :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe Meal, :type => :model do
  it "is valid with description, sequence number " do
  	meal = Meal.new(description: 'Mains', seq: 20)
  	expect(meal).to be_valid
  end
  
  it "is invalid without a sequence number" do
  	meal = Meal.new(description: 'Mains', seq: nil)
  	meal.valid?
  	expect(meal.errors[:seq]).to include("can't be blank")
  end
  
  it "is invalid without a description" do
  	meal = Meal.new(description: nil, seq: 30)
  	meal.valid?
  	expect(meal.errors[:description]).to include("can't be blank")
  end
  
  it "is valid to have many recipies" do
  	meal = Meal.new(description: 'Mains', seq: 20)
  	desc =  Issuedescription.new(title: 'Apr', full_title: 'April', seq: 3)
  	issue =  desc.issues.new(title: '78', year: 2004)
  	recipe = issue.recipes.new(title: 'rack of pork with cider apples', page: 64, meal_id: meal.id)
  
  	expect(recipe).to be_valid
  end
end
