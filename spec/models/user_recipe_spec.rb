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

require 'rails_helper'

RSpec.describe UserRecipe, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
