# == Schema Information
#
# Table name: issuemonths
#
#  id                  :integer          not null, primary key
#  monthindex          :integer
#  issuedescription_id :integer
#  created_at          :datetime
#  updated_at          :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :issuemonth do
    monthindex 1
    issuedescription nil
  end
  
  factory :issuemonth_with_description, class: Issuemonth do
  	issuedescription
	end
end
