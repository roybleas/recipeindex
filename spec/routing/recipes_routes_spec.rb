require 'rails_helper'

RSpec.describe "routes to the recipe controller" do
  it "routes a month to by month route" do
    expect(:get => "/bymonth/1").
      to route_to(:controller => "recipes", :action => "bymonth", :id => "1")
  end
  it "routes every month to bymonth route" do
  	(1..12).each{ |m| 
    expect(:get => bymonth_path(m)).
      to route_to(:controller => "recipes", :action => "bymonth", :id => "#{m}")
    }
  end
  context "fails to route an invalid month " do
	  it "of zero" do
	    expect(:get => "/bymonth/0").not_to be_routable
		end
		it "> 12" do
	    expect(:get => "/bymonth/13").not_to be_routable
		end
		it "non numeric" do
	    expect(:get => "/bymonth/jan").not_to be_routable
		end
  end

end