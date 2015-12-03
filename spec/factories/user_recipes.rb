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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_recipe do
    user nil
    recipe nil
    comment "Comment for user_recipe"
    lastused nil
  end
  factory :user_recipe_with_date, class: UserRecipe do
  	like 1
  	rating 2
  	comment "Comment for user_recipe with a date"
  	lastused Date.new(2015,11,23)
  end
end
