# == Schema Information
#
# Table name: category_recipes
#
#  id          :integer          not null, primary key
#  keyword     :string
#  category_id :integer
#  recipe_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe CategoryRecipe, :type => :model do
  it "can have many recipe records linked to a category" do
  	cattype = Categorytype.create(name: "Ingredient", code: "I")
		category = cattype.categories.create(name: "bananas")
		recipe = Recipe.create(title: "banana bread" ,page: 91)
		catrec = category.category_recipes.create(recipe: recipe)
		expect(catrec).to be_valid
	end
	
	it "can have an optional keyword " do
  	cattype = Categorytype.create(name: "Ingredient", code: "I")
		category = cattype.categories.create(name: "apples")
		recipe = Recipe.create(title: "apple cake" ,page: 91)
		catrec = category.category_recipes.create(recipe: recipe, keyword: 'apple')
				
		expect(catrec).to be_valid
	end
	
  it "can have many category records linked to a recipe" do
  	cattype = Categorytype.create(name: "Ingredient", code: "I")
		category = cattype.categories.create(name: "bananas")
		
		recipe = Recipe.create(title: "banana bread" ,page: 91)
		recipe.save
		catrec = recipe.category_recipes.new(category: category)
		expect(catrec).to be_valid
		
		cattype = Categorytype.create(name: "Product", code: "P")
		category = cattype.categories.create(name: "breads")
		catrec = recipe.category_recipes.new(category: category)
		expect(catrec).to be_valid
	end
	
end

