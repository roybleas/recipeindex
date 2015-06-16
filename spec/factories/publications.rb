# == Schema Information
#
# Table name: publications
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  published   :string(255)
#  description :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :publication do
    sequence(:title) {|n| "Publication #{n}" }
    published "Monthly"
   	description "A food magazine."
  end
end

