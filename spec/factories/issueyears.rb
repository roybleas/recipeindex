# == Schema Information
#
# Table name: issueyears
#
#  id             :integer          not null, primary key
#  year           :integer
#  publication_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :issueyear do
    year 1
    publication nil
  end
end
