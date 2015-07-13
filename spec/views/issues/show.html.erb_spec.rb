require 'rails_helper'

RSpec.describe "issues/show.html.erb", :type => :view do
	
	context "with Publication,Issue " do
    before(:each) do
      assign(:pub, Publication.new(title: "Delicious"))
      @this_issue = Issue.create(no: 123, year: 2001)
   		assign(:issue,@this_issue)
   		assign(:issuedesc,Issuedescription.new(title: "April"))
   		assign(:previous_issuedescription, FactoryGirl.create(:issue_without_description, year: 2000))
   		assign(:next_issuedescription, FactoryGirl.create(:issue_without_description, year: 2002))
   		this_recipe = FactoryGirl.create(:recipe , page: 102, title: "Baked kumara with yoghurt dressing", issue_id: @this_issue.id)
   		assign(:recipes, [this_recipe])
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
	  	assign(:issue,Issue.create(title: "OneTwoThree", year: 2001))
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
	  it "displays a recipe with a link " do
	  	assign(:recipes, [  FactoryGirl.create(:recipe , page: 103, title: "Baked Alaska", url: "www.awebsite.com.au/recipe1.html", issue_id: @this_issue.id)])
	  	render 
	  	expect(rendered).to match /103/
	  	expect(rendered).to match /Baked Alaska/
	  	expect(rendered).to match /href="www.awebsite.com.au\/recipe1.html"/
	  end
	  
	  it "displays a tick to show user owns it" do
	  	
	  end
	  
	end
end
