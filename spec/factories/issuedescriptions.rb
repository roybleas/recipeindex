# == Schema Information
#
# Table name: issuedescriptions
#
#  id             :integer          not null, primary key
#  title          :string
#  full_title     :string
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
	   
	   factory :issuedescription_with_years_and_user, class: Issuedescription do
	  	title "Jun-Jul"
    	full_title "June-July"
    	seq 10
    	
	  	ignore do
    		issues_count 5
    		user_name "UserIssueOwner"
    	end
    	
	   	after(:create) do |issuedescription , evaluator|
	   		user1 = User.find_by_name(evaluator.user_name) || FactoryGirl.create(:user, name: evaluator.user_name)
	   			   			
	    	issue_list = create_list(:issue, evaluator.issues_count, issuedescription: issuedescription)
	    	issue_list.each do |issue| 
	    		ui = create(:user_issue, user_id: user1.id, issue_id: issue.id)
	    	end
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
  	  	
  	factory :issuedescription_list_with_an_issue, class: Issuedescription do
    	
	  	ignore do
    		yr 1990
    		issue_count 3
    	end
    	
	   	after(:create) do |issuedescription , evaluator|
	   		
	   		this_year = evaluator.yr.to_i
	   		 evaluator.issue_count.to_i.times do
	    		create(:issue_without_description, issuedescription: issuedescription, year: this_year)
	    		this_year += 1 
	    	end
	    end
	   end
  end
  factory :issuedescription_with_single_issue_multi_issuemonths, class: Issuedescription do
		title "Feb-Mar"
    full_title "February-March"
    seq 1
    
    ignore do
    	month_index 2
    	issue_month_count 2
    end
    
    after(:create) do |issuedescription, evaluator|
    	this_monthindex = evaluator.month_index
    	this_monthindex.to_i
    	evaluator.issue_month_count.to_i.times do
	  		create(:issuemonth_with_description, monthindex: this_monthindex, issuedescription: issuedescription)
	  		this_monthindex += 1
	  	end
	  	
	  end
	end
	
end
