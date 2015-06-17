require 'rails_helper'

RSpec.describe "publications/issues.html.erb", :type => :view do
  
  before(:each) do
  	pub = create(:publication, title: "Test title 1")
  	assign(:publication, pub)	
		@isdesc = []
		@isdesc << create(:issuedescription_list_with_an_issue, publication_id: pub.id, issue_count: 2, yr: 2001)
		@isdesc << create(:issuedescription_list_with_an_issue, publication_id: pub.id, issue_count: 2, yr: 2001)
		assign(:issuedescriptions, @isdesc)
		@issues_list = @isdesc.inject([]) { |issues_group, issuedesc| issues_group  +  issuedesc.issues }
 		assign(:issues , @issues_list)
  end
  
  
   it "displays the issues template" do
  	render
  	expect(view).to render_template("publications/issues")
  end
	
	it "displays a publication title" do
  	render
  	assert_select 'h1',"Test title 1"
  end	
  
  it "displays a table header for year" do
  	render
  	assert_select 'th',"Year"
  end	
  
  it "displays a table header for each issue description " do
  	render
  	@isdesc.each do |isdesc|
  		assert_select 'th',isdesc.title
  	end
  end	
  
  it "displays a table row header for each issue year " do
  	render
  	assert_select 'th',"2001"
  	assert_select 'th',"2002"
  end	
  
  it "dispalys a link in the table for an issue" do
  	render
  	assert_select "a[href=?]", "/issues/#{@issues_list[0].id}"
  end
end
