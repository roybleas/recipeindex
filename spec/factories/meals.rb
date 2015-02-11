# == Schema Information
#
# Table name: meals
#
#  id          :integer          not null, primary key
#  description :string(255)
#  seq         :integer
#  created_at  :datetime
#  updated_at  :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :meal do
    description "MyString"
    seq 1
  end
end
