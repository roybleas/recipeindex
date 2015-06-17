require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the IssuesHelper. For example:
#
# describe IssuesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, :type => :helper do
	
	describe "publications" do
		
	 	before(:each) do
      issuedescription = create(:issuedescription)
      @publication = [issuedescription.publication]
      publication = create(:publication, title: "But not displayed")
    end
    
    it "fetches a list of current publications" do
    	expect(helper.publications()).to eq(@publication)
    end
	 	
	end

end