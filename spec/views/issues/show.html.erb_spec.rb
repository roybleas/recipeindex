require 'rails_helper'

RSpec.describe "issues/show.html.erb", :type => :view do
	
	context "with Publication,Issue " do
    before(:each) do
      assign(:pub, Publication.new(title: "Delicious"))
   		assign(:issue,Issue.new(no: 123, year: 2001))
   		assign(:issuedesc,Issuedescription.new(title: "April"))
   		assign(:previous_issuedescription, FactoryGirl.create(:issue_without_description, year: 2000))
   		assign(:next_issuedescription, FactoryGirl.create(:issue_without_description, year: 2002))
   		assign(:recipes, [ Recipe.new(page: 102, title: "Baked kumara with yoghurt dressing")])
   		
   	end
	
	
	  it "displays a publication title" do
	    render
			expect(rendered).to match /Delicious/
	  end
	  it "displays an issue No " do
	  	render 
	  	expect(rendered).to match /123/
	  end
	  it "display an issue title" do
	  	assign(:issue,Issue.new(title: "OneTwoThree", year: 2001))
	  	render
	  	expect(rendered).to match /OneTwoThree/
	  end
	  it "displays an issue year " do
	  	render 
	  	expect(rendered).to match /2001/
	  end
	  it "displays an issue description title " do
	  	render 
	  	expect(rendered).to match /April/
	  end
	  it "displays a recipe " do
	  	render 
	  	expect(rendered).to match /102/
	  	expect(rendered).to match /Baked kumara/
	  end
	  
	  
	end
end