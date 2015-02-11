# == Schema Information
#
# Table name: issues
#
#  id                  :integer          not null, primary key
#  title               :string(255)
#  publication_id      :integer
#  issueyear_id        :integer
#  issuedescription_id :integer
#  created_at          :datetime
#  updated_at          :datetime
#  no                  :integer
#

require 'rails_helper'

RSpec.describe Issue, :type => :model do
  it "is valid with a title and number" do
  	issue = Issue.new(title: "20", no: 30)
  	expect(issue).to be_valid
  end
  
  it "is valid with just a title and no number" do
  	issue = Issue.new(title: "20", no: nil)
  	expect(issue).to be_valid
  end
  
  it "is valid with just a number and no title" do
  	issue = Issue.new(title: nil, no: 30)
  	expect(issue).to be_valid
  end
  
  it "is invalid without a title and number" do
  	issue = Issue.create(title: nil, no: nil)
  	expect(issue.errors[:title]).to include("can't be blank")
  end 
  
	it "can have many records to a publication" do
		pub = Publication.new(title: "Dish")
		issue = pub.issues.new(no: 21)
		expect(issue).to be_valid
	end
	
	it "can have many records to an issue year" do
		pub = Publication.create(title: "Dish")
		yr = pub.issueyears.create(year: 2004)
		issue = yr.issues.create(title: "Spring")
		expect(issue).to be_valid
	end
	
	it "can have many records to an issue year" do
		pub = Publication.create(title: "Dish")
		desc = pub.issuedescriptions.create(title: "May", full_title: "May", seq: 5)
		yr = pub.issueyears.create(year: 2005)
		issue = desc.issues.create(title: "23",issueyear_id: yr.id)
		expect(issue).to be_valid
		
		
	end
end
