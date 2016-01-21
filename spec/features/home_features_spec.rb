require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers
feature 'Home page' do

  scenario "Visit Home page" do
		visit root_path
		expect(page).to have_content('Recipe Finder')
	end

	scenario "have link to this month issue for selected year" do
		travel_to Time.new(2015, 2, 3) do
				
			create(:publication)
			issuedescription = create(:issuedescription)
			issuemonth = create(:issuemonth,issuedescription_id: issuedescription.id,monthindex: 2)
		  issue = create(:issue, issuedescription_id: issuedescription.id, year:2014)
		  
		  visit root_path
		  click_link("2014")
			expect(current_path).to eq issue_path(issue)
		
		end
	end

end
