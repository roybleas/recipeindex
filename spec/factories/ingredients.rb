# == Schema Information
#
# Table name: ingredients
#
#  id         :integer          not null, primary key
#  ingredient :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ingredient do
    ingredient "asparagus"
  end
end
