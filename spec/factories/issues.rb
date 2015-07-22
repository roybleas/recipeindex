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
class Issue_and_description < Issue 
	attr_accessor :issuedescription_title
	attr_accessor :publication_title
	
end

FactoryGirl.define do
  factory :issue do
    sequence(:year, 1990)
  	sequence(:no)
    issuedescription
  end

	factory :issue_without_description, class: Issue do
		sequence(:year, 1998)
  	sequence(:no, 100)
	end
	
	factory :issue_with_descriptiontitle, class: Issue_and_description, parent: :issue_without_description do
  	issuedescription_title "Aug"
  	publication_title "Delicious"
  	sequence(:year, 1998)
	end
	
	
		
	
end


