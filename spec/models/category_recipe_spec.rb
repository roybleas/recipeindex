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

require 'rails_helper'

RSpec.describe CategoryRecipe, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
