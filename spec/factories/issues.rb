# == Schema Information
#
# Table name: issues
#
#  id                  :integer          not null, primary key
#  title               :string(255)
#  issuedescription_id :integer
#  created_at          :datetime
#  updated_at          :datetime
#  no                  :integer
#  year                :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :issue do
    sequence(:year, 2001)
  	sequence(:no)
    issuedescription
  end

	factory :issue_without_description, class: Issue do
		sequence(:year, 1998)
  	sequence(:no, 100)
	end
end
