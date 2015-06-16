# == Schema Information
#
# Table name: issuedescriptions
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  full_title     :string(255)
#  seq            :integer
#  publication_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	
  factory :issuedescription do
    title "Feb-Mar"
    full_title "February-March"
    seq 1
    publication
	 
	 	 # issuedescription_with_years will create issue data after the issuedescription has been created
		factory :issuedescription_with_years, class: Issuedescription do
	  	title "Apr-May"
    	full_title "April-May"
    	seq 2
    	
	  	ignore do
    		issues_count 5
    	end
    	
	   	after(:create) do |issuedescription , evaluator|
	    	create_list(:issue, evaluator.issues_count, issuedescription: issuedescription)
	    end
	   end
	end
	
	factory :issuedescription_with_single_issue, class: Issuedescription do
		title "Jun"
    full_title "June"
    seq 5
    
    ignore do
    	issue_id 123
    end
    after(:create) do |issuedescription, evaluator|
	  	create(:issue, id: evaluator.issue_id, issuedescription: issuedescription, year: 2010)
	  end
	end
	
	 
	 	
	factory :issuedescription_list, class: Issuedescription do
  	sequence(:title) {|n| "Title #{n}" }
  	sequence(:full_title) { |n| "Full title #{n}" }
  	sequence(:seq) 
  	  	
  	factory :issuedescription_list_with_issues, class: Issuedescription do
    	
	  	ignore do
    		issue_count 3
    		yr 2009
    	end
    	
	   	after(:create) do |issuedescription , evaluator|
	    	create_list(:issue_with_set_year, evaluator.issue_count, issuedescription: issuedescription, year: evaluator.yr)
	    end
	   end
  end
end
