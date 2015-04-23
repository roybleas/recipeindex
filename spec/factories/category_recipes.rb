# == Schema Information
#
# Table name: category_recipes
#
#  id          :integer          not null, primary key
#  category_id :integer
#  recipe_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category_recipe do
    category nil
    recipe nil
  end
end
