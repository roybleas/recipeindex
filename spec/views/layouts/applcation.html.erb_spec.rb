require 'rails_helper'

RSpec.describe "layouts/application.html.erb", :type => :view do
	
	
	context "navigation menu" do
		before(:each) do
			@publications = [create(:publication)]
			allow(view).to receive(:publications).and_return(@publications)
		end
			
		it "has a Home tab" do
			render
			assert_select 'li', "Home"
			assert_select "a[href=?]", "/"
		end
		it "has a Categories tab" do
			render
			assert_select 'li', "Indexes"
			assert_select "a[href=?]", "/categories"
		end
		it "has an Issues tab" do			
			render
			assert_select 'a.dropdown-toggle', "Issues"
		end
		
		it "has a menu of publications for issues" do
			render
			assert_select 'li', @publications[0].title
			assert_select "a[href=?]", "/publications/" + @publications[0].id.to_s + "/issues"
		end
		
	end
	context "navigate when not logged in" do
		before(:each) do
			allow(view).to receive_messages(:logged_in? => false)
		end
		
		it "has a link to log in" do
			render
			assert_select 'li', "Log in"
			assert_select "a[href=?]", "/login"
		end
	end
	context "navigate when logged in" do
		before(:each) do
			allow(view).to receive_messages(:logged_in? => true)
			@user = create(:user)
			allow(view).to receive(:current_user).and_return(@user)
		end
		
		it "does not have a link to login" do
			render
			assert_select 'li', {:text=> "Log in", :count=> 0 }
		end
		it "has a user name" do
			render
			assert_select 'a.dropdown-toggle', /User:\s+#{@user.screen_name}/
		end
		it "has a link to profile" do
			render
			assert_select 'li', "Profile"
			assert_select "a[href=?]", "/users/" + @user.id.to_s
		end
		it "has a link to Log out" do
			render
			assert_select 'li', "Log out"
			assert_select "a[href=?]", "/logout" 
			assert_select "a[data-method=?]", "delete"
		end
	end
	context "navigate when logged in as admin" do
		before(:each) do
			allow(view).to receive_messages(:admin_user? => true)
			allow(view).to receive_messages(:logged_in? => true)
			@user = create(:user)
			allow(view).to receive(:current_user).and_return(@user)
		end
		it "has a heading of Admin" do
			render
			assert_select 'a.dropdown-toggle', "Admin"
		end
		it "has a link to publications list" do
			render
			assert_select 'li', "Publications"
			assert_select "a[href=?]", "/admin_pages/home"
		end		
		it "has a link to all users list" do
			render
			assert_select 'li', "All Users"
			assert_select "a[href=?]", "/users"
		end
	end
	context "navigate when not logged in as admin" do
		before(:each) do
			allow(view).to receive_messages(:admin_user? => false)
			allow(view).to receive_messages(:logged_in? => true)
			@user = create(:user)
			allow(view).to receive(:current_user).and_return(@user)
		end
		
		it "doen not have admin options" do
			render
			assert_select 'li', {:text=> "Admin", :count=> 0 }
			assert_select 'li', {:text=> "Publications", :count=> 0 }
			assert_select 'li', {:text=> "All Users", :count=> 0 }
		end
	end
end