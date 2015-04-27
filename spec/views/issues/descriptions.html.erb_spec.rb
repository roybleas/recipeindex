require 'rails_helper'

RSpec.describe "issues/descriptions.html.erb", :type => :view do
	context "with Publication " do
    before(:each) do
      assign(:pub, Publication.new(title: "Delicious"))
   		assign(:issue_id,1)
   		assign(:descriptions,
   		 [
      	double(:Issuedescription, :full_title => "April", :seq => 7,
      		:issue => double(:Issue, :id => 1)
      		)
    		])
	
   	end
	
	  it "displays a publication title" do
	    render
			expect(rendered).to match /Delicious/
	  end
	 
	 it "displays a button for an issue description" do	  	
	  	render
	  	expect(rendered).to match /April/
	  	expect(rendered).to match /btn-primary/
	  	expect(rendered).to_not match /btn-default/
	  end
	  
	  it "displays a button for multiple issue descriptions " do
	  	assign(:descriptions,
   		 [
      	double(:Issuedescription, :full_title => "April", :seq => 7,
      		:issue => double(:Issue, :id => 1)
      		),
      	double(:Issuedescription, :full_title => "May", :seq => 8,
      		:issue => double(:Issue, :id => 2)
      		)
    		])
	  	assign(:issue_id, 2)
	  	render 
	  	expect(rendered).to match /May/
	  	expect(rendered).to match /btn-primary/
	  	expect(rendered).to match /btn-default/
	  end
	end
end