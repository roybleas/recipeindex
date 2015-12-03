# == Schema Information
#
# Table name: user_recipes
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  recipe_id  :integer
#  rating     :integer          default("0")
#  like       :integer          default("0")
#  comment    :string
#  lastused   :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe UserRecipe, :type => :model do
	before (:each) do
  	@recipe = create(:recipe_with_issue)
  	@user = create(:user)
  	@user_recipe = create(:user_recipe, user_id: @user.id, recipe_id: @recipe.id)
	end
		
  it "can have a recipe record linked to a user" do
  	expect(@user_recipe).to be_valid
	end
	
	it "can have many user records linked to a recipe" do
  	user2 = create(:user, name: "RecipeUser2")
  	user_recipe2 = create(:user_recipe, user_id: user2.id, recipe_id: @recipe.id)
  	expect(user_recipe2).to be_valid
	end
	it "can have many recipe records linked to a user" do
  	recipe2 = create(:recipe_with_issue)
  	user_recipe3 = create(:user_recipe, user_id: @user.id, recipe_id: recipe2.id)
  	expect(user_recipe3).to be_valid
	end
	
	it "has a rating value greater than 0" do
		user_recipe = build(:user_recipe, rating: 1)
		expect(user_recipe).to be_valid
	end
	it "has a rating value less than 6" do
		user_recipe = build(:user_recipe, rating: 5)
		expect(user_recipe).to be_valid
	end
	it "cannot have a rating value greater than 5" do
		user_recipe = build(:user_recipe, rating: 6)
		user_recipe.valid?
		expect(user_recipe.errors[:rating]).to include("is outside the valid range.")
	end
	it "cannot have a rating value less than 0" do
		user_recipe = build(:user_recipe, rating: -1)
		user_recipe.valid?
		expect(user_recipe.errors[:rating]).to include("is outside the valid range.")
	end
	
	it "has a default like value of 0" do
		user_recipe = build(:user_recipe)
		expect(user_recipe.like).to eq(0)
	end
	it "can have a like value of 1" do
		user_recipe = build(:user_recipe, like: 1)
		expect(user_recipe.like).to eq(1)
	end
	it "can have a like value of -1" do
		user_recipe = build(:user_recipe, like: -1)
		expect(user_recipe.like).to eq(-1)
	end
	it "cannot have a like value greater than 1" do
		user_recipe = build(:user_recipe, like: 2)
		user_recipe.valid?
		expect(user_recipe.errors[:like]).to include("is outside the valid range.")
	end
	it "cannot have a like value less than -1" do
		user_recipe = build(:user_recipe, like: -2)
		user_recipe.valid?
		expect(user_recipe.errors[:like]).to include("is outside the valid range.")
	end

end
