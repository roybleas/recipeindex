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

class UserRecipe < ActiveRecord::Base
  belongs_to :user
  belongs_to :recipe
  
  validates_inclusion_of :rating, in: 0..5, :message => "is outside the valid range."
  validates_inclusion_of :like, in: -1..1, :message => "is outside the valid range."
end
