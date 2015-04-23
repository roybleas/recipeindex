# == Schema Information
#
# Table name: ingredient_recipes
#
#  id            :integer          not null, primary key
#  ingredient_id :integer
#  recipe_id     :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require 'rails_helper'

RSpec.describe IngredientRecipe, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
