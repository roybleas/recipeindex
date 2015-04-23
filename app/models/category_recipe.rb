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

class CategoryRecipe < ActiveRecord::Base
   belongs_to :category
   belongs_to :recipe
end
