require 'rails_helper'

RSpec.describe "issues/years.html.erb", :type => :view do
	
	context "with Publication,Issue " do
    before(:each) do
      assign(:pub, Publication.new(title: "Delicious"))
   		assign(:issue_id,1)
   		assign(:years, [create(:issue_without_description, year: 2000)])
   	end
	
	  it "displays a publication title" do
	    render
			expect(rendered).to match /Delicious/
	  end

	  it "displays an a description for a single year index " do
	  	render 
	  	expect(rendered).to match /year:/
	  	expect(rendered).to_not match /years:/
	  end

	  it "displays an a description for a multiple year indexes " do
	  	assign(:years, [create(:issue_without_description, year: 2000),
	  		create(:issue_without_description, year: 2001)]
	  	)
	  	render 
	  	expect(rendered).to_not match /year:/
	  	expect(rendered).to match /years:/
	  end
	  
	  it "displays a button for a year" do	  	
	  	render
	  	expect(rendered).to match /2000/
	  	expect(rendered).to match /btn-primary/
	  	expect(rendered).to_not match /btn-default/
	  end
	  
	  it "displays a button for multiple years " do
	  	assign(:years, [create(:issue_without_description, year: 2002),
	  		create(:issue_without_description, year: 2003 , id: 3) ]
	  	)
	  	assign(:issue_id, 3)
	  	render 
	  	expect(rendered).to match /2002/
	  	expect(rendered).to match /btn-primary/
	  	expect(rendered).to match /btn-default/
	  end
	  
	end
end
