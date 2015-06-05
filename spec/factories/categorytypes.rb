# == Schema Information
#
# Table name: categorytypes
#
#  id         :integer          not null, primary key
#  code       :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :categorytype do
  	sequence(:code) { |n| "#{n}" }
  	sequence(:name) { |n| "Type #{n}" }
  end
end
