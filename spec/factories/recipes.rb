# == Schema Information
#
# Table name: recipes
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  page       :integer
#  url        :string(255)
#  issue_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
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
