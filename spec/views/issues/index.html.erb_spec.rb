require 'rails_helper'

RSpec.describe "issues/index.html.erb", :type => :view do
	before(:each) do
		assign(:mnth, 2)
		assign(:pubs, [create(:publication)])
	end
  it "displays the index template" do
  	render
  	expect(view).to render_template(:index)
  end
  it "shows a message when no publications exist" do
  	assign(:pubs, [])
  	expect(render).to match /No publications added /
  end
  it "shows multiple publication titles" do
  	p = Array.new(2){create(:publication)}
  	assign(:pubs, p) 
  	render
  	expect(rendered).to match /#{p[0].title}/
  	expect(rendered).to match /#{p[1].title}/
  end
  it "shows a message when no issues set up" do
  	expect(render).to match /No indexes available for this publication/
  end 
  context "show issue years" do
  	before(:each) do
	  	issuedescription = create(:issuedescription)
	  	issuemonth = create(:issuemonth,issuedescription_id: issuedescription.id,monthindex: 2)
	  	issue = create(:issue, issuedescription_id: issuedescription.id, year:2014)
	  	@issuedescription_id = issuedescription.id
	  	assign(:pubs, Publication.all)
		end  		
	  it "shows an issue year for current month" do
	  	render
	  	expect(rendered).to match /2014/
	  	expect(rendered).to match /Indexes available for the following/
	  	expect(rendered).to match /year:/
	  end
	  it "shows an issue for multiple years for current month" do
	  	issue = create(:issue, issuedescription_id: @issuedescription_id, year:2015)
	  	render
	  	expect(rendered).to match /2014/
	  	expect(rendered).to match /2015/
	  	expect(rendered).to match /Indexes available for the following/
	  	expect(rendered).to match /years:/
	  end
	end
end
