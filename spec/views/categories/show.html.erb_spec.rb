require 'rails_helper'

RSpec.describe "categories/show.html.erb", :type => :view do
  
  before(:each) do
  	@cattype = create(:categorytype, code: 'I')
  	@cat = create(:category,  :categorytype => @cattype )
  	assign(:category, @cat)
  	assign(:recipes, [])
	end	
  
  context "view a category " do
  	it "displays the show template" do
  		
  		render
  		expect(view).to render_template(:show)
  	end
  	it "displays a category name" do
  		render
  		expect(rendered).to match /#{@cat.name}/ 
  	end
  end
  
  context "view category without recipes" do
  	it "displays no recipes availbale" do
  		render 
  		expect(rendered).to match /No recipes available/
  	end
	end
end
