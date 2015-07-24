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

class UserRecipe < ActiveRecord::Base
  belongs_to :user
  belongs_to :recipe
  
  validates_inclusion_of :rating, in: 0..5
end
