require 'rails_helper'

RSpec.describe "publications/index.html.erb", :type => :view do
  
   it "displays an array of publication titles" do
    assign(:publications, [
      Publication.new(:title => "Delicious"),
      Publication.new(:title => "Dish")
    ])

    render

		expect(rendered).to match /Delicious/
		expect(rendered).to match /Dish/
   
  end
  
  it "displays Published: and published value when published is present" do
  	
    assign(:publications,[ 
      Publication.new(:title => "Delicious", :published => "Monthly")
			])
			
    render

		expect(rendered).to match /Published:/
		expect(rendered).to match /Monthly/

  end
  
   it "hides Published: when published value is nil" do
  	
    assign(:publications,[
      Publication.new(:title => "Masterchef", :published => nil)
      ])

    render

    expect(rendered).to_not match /Published:/
		expect(rendered).to_not match /Monthly/
  end
end
