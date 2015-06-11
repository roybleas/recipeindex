require 'rails_helper'

RSpec.describe "layouts/application.html.erb", :type => :view do
	context "navigation menu" do
		it "has a Home tab" do
			render
			assert_select 'li', "Home"
			assert_select "a[href=?]", "/"

		end
		it "has a Categories tab" do
			render
			assert_select 'li', "Categories"
			assert_select "a[href=?]", "/categories"
			
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
end