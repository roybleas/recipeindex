# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  category   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Category < ActiveRecord::Base
	has_many :category_recipes
	has_many :recipes, through: :category_recipes
	
	validates :category, presence: true
end