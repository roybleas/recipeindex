# == Schema Information
#
# Table name: ingredients
#
#  id         :integer          not null, primary key
#  ingredient :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Ingredient < ActiveRecord::Base
	has_many :ingredient_recipes
	has_many :recipes, through: :ingredient_recipes
	
	validates :ingredient, presence: true
end
