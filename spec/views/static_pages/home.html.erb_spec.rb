require 'spec_helper'

RSpec.describe "static_pages/home.html.erb", :type => :view do
 
  it "displays the header Recipe Index" do
  	
   	render
		expect(rendered).to match /Recipe Finder/
  end
end
