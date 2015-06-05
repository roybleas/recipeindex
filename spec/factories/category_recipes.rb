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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category_recipe do
    keyword "MyString"
    category nil
    recipe nil
  end
end
