# == Schema Information
#
# Table name: ingredients
#
#  id         :integer          not null, primary key
#  ingredient :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Ingredient, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
