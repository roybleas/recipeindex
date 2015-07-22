require 'rails_helper'

RSpec.describe "users/show.html.erb", :type => :view do
  context "view profile" do
  	before (:each) do
  		@user = create(:user)
  	end
  	
  	it "shows the user name and screen name" do
  		render
  		assert_select 'h3',"Name: " + @user.name
  		assert_select 'h3',"Screen Name: " + @user.screen_name
  	end
  
  
  	context "issue ownership" do
  		it "shows zero issues owned" do
  			@issuecounts = []
  			render
  			assert_select 'p',"No issues owned."
  		end
  		it "shows no issues exist" do
  			@issuecounts = nil
  			render
  			assert_select 'p',"No issues owned."
  		end

  		it "shows zero issues owned" do
  			@issuecounts = {"Publication 1" => 5, "Publication 2" => 3}
  			render
  			assert_select 'li',"Publication 1 Issues Owned: 5"
  			assert_select 'li',"Publication 2 Issues Owned: 3"
  		end
  	end
  end
  	
  		
end