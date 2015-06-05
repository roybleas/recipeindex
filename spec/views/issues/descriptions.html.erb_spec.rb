require 'rails_helper'

RSpec.describe "issues/descriptions.html.erb", :type => :view do
	context "with View of Issue descriptions " do
    before(:each) do
      assign(:pub, create(:publication, title: "My test publication title"))
   		descs =  [create(:issuedescription_with_single_issue, full_title: "April")]
   		assign(:issue_id,descs.first.issues.first.id)
 			assign(:descriptions, descs)
   	end
	
	  it "displays a publication title" do
	    render
			expect(rendered).to match /My test publication title/
	  end
	 
	 it "displays a button for an issue description" do	 	
	  	render
	  	expect(rendered).to match /April/
	  	expect(rendered).to match /btn-primary/
	  	expect(rendered).to_not match /btn-default/
	  end
	  
	  it "displays a button for multiple issue descriptions " do
	  	descs =  [create(:issuedescription_with_single_issue, full_title: "April", issue_id: 124),
	  		create(:issuedescription_with_single_issue, full_title: "May", issue_id: 125)]
	  	assign(:descriptions, descs)
	  	assign(:issue_id , descs.last.issues.first.id)
	  	
  		render 
	  	expect(rendered).to match /May/
	  	expect(rendered).to match /btn-primary/
	  	expect(rendered).to match /btn-default/
	  end
	  
	  it "display a link to the issue with the issue id" do
	  	render
	  	expect(rendered).to match /\/issues\/123/
	  end
	end
end