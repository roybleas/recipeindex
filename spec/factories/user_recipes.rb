# == Schema Information
#
# Table name: user_recipes
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  recipe_id  :integer
#  rating     :integer
#  like       :integer          default("0")
#  comment    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_recipe do
    user nil
    recipe nil
    rating 1
    comment "Comment for user_recipe"

  end
end
