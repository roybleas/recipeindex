require 'rails_helper'

RSpec.describe "categories/index.html.erb", :type => :view do
  
  before(:each) do
  	# create the tab letter ranges
    @letter_ranges = [%w[a b], %w[c d],%w[e m],%w[n p], %w[q z]]
		assign(:letter_ranges, @letter_ranges)
		assign(:categories, [])
	end	
	
  context "view the categories " do
  	it "displays the index template" do
  		assign(:letter, @letter_ranges[0])
  		render
  		expect(view).to render_template(:index)
  	end
  	it "displays a title" do
  		render
  		expect(rendered).to match /Categories/ 
  	end
  end
  	
  context "view a set category tabs for index " do
    before(:each) do   	
    	assign(:letters, @letter_ranges[0])
    end
    
    it "displays a set of tabs" do
	    render
	  	@letter_ranges.each do |range| 
	  		regex = "#{range[0]} - #{range[1]}"
	  		expect(rendered).to match regex
	  	end
	  end
	  
	  it "displays the default tab a " do
	  	render
	  	expect(rendered).to match /class=active\s*>\s*<a href="\/categories\/byletter\/a">a - b<\/a>/
	  end
	  
	  it "displays a message if no categories found " do
	  	render
	  	expect(rendered).to match /No categories found/
	  end
	end
   	
  context "view categories" do
  	before(:each) do
  		@cattype = create(:categorytype, code: 'I')
  	end
  	
  	it "displays a single category" do
  		
  		cats = [create(:category,  :categorytype => @cattype )]
  		assign(:columnheight, 1)
  		assign(:categories, cats)
  		render
  		regex = "#{cats.first.name}"
  		expect(rendered).to match regex
  	end
  end
   	
end
