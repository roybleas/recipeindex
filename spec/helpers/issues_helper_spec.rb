require 'rails_helper'


RSpec.describe IssuesHelper, :type => :helper do
	
	describe "on change of year return end of row" do
		it "excludes final row tag when returning initial row" do
			curr_year = IssuesHelper::CurrentYear.new
			expect(curr_year.add_new_row_on_change_of_year(2001)).to_not include(" </tr>")
		end
		
		it "includes final row tag when returning a change of row" do
			curr_year = IssuesHelper::CurrentYear.new
			curr_year.add_new_row_on_change_of_year(2001)
			expect(curr_year.add_new_row_on_change_of_year(2002)).to eq(" </tr><tr><th> 2002</th> ")
		end
		
		it "returns blank when same year" do
			curr_year = IssuesHelper::CurrentYear.new
			curr_year.add_new_row_on_change_of_year(2001)
			expect(curr_year.add_new_row_on_change_of_year(2001)).to be_empty
		end
	end 
		
	
  describe "user has a copy of issue" do
  	before(:each) do
  		@issue = create(:issue, year: 2000)
  	end
  	it "does not have a copy when not logged in" do
  		allow(view).to receive_messages(:logged_in? => false)
  		expect(helper.user_has_copy_of_issue(@issue)).to be_empty
  	end
  	context "logged in" do
  		before(:each) do
  			@user = create(:user)
  			allow(view).to receive_messages(:logged_in? => true)	
  			allow(view).to receive_messages(:current_user => @user)
  		end
  		
  		it "does not have copy when no matching User Issue record" do 			
  			expect(helper.user_has_copy_of_issue(@issue)).to be_empty
  		end
  		it "when a matching User Issue record" do
  			user_issue = create(:user_issue, user_id: @user.id, issue_id: @issue.id)
  			expect(helper.user_has_copy_of_issue(@issue)).to include("glyphicon glyphicon-ok")
  		end
  	end
  	
  end
end
