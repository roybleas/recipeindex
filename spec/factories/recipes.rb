# == Schema Information
#
# Table name: recipes
#
#  id         :integer          not null, primary key
#  title      :string
#  page       :integer
#  url        :string
#  issue_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	# Issue id needs to be set when creating recipe
	# @recipe = create(:recipe, issue_id: @issue.id)
  factory :recipe do
    title "Baked Alaska"
    sequence(:page)
  end
  
  factory :recipe_with_issue, class: Recipe do
  	sequence(:page)
  	sequence(:title) { |n| "RecipeTitle#{n}" }
  	association :issue, factory: :issue_without_description, year: 2002
  end
end
