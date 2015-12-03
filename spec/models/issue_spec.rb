# == Schema Information
#
# Table name: issues
#
#  id                  :integer          not null, primary key
#  title               :string
#  issuedescription_id :integer
#  created_at          :datetime
#  updated_at          :datetime
#  no                  :integer
#  year                :integer
#

require 'rails_helper'

RSpec.describe Issue, :type => :model do
  it "is valid with a title number and year" do
  	issue = Issue.new(title: "20", no: 30, year: 2001)
  	expect(issue).to be_valid
  end
  
  it "is valid with just a title and year but no number" do
  	issue = Issue.new(title: "20", no: nil, year: 2001)
  	expect(issue).to be_valid
  end
  
  it "is valid with just a number and year and no title" do
  	issue = Issue.create(title: nil, no: 30, year: 2001)
  	expect(issue).to be_valid
  end
  
  it "is invalid with a year but without a title and number" do
  	issue = Issue.create(title: nil, no: nil, year: 2001)
  	issue.valid?
  	expect(issue.errors[:no]).to include("can't be blank")
  end 
  
  it "is invalid with a number but without a year" do
  	issue = Issue.create(title: nil, no: 30, year: nil)
  	issue.valid?
  	expect(issue.errors[:year]).to include("can't be blank")
  end 

  it "is invalid with a title but without a year" do
  	issue = Issue.create(title: "20", no: nil, year: nil)
  	expect(issue.errors[:year]).to include("can't be blank")
  end 

	it "is invalid with a year less than 1990" do
		yr = Issue.create(year:1989, no: 21)
		expect(yr.errors[:year]).to include("must be greater than 1989")
	end
  	
  it "is invalid with a year greater than this year" do
  	next_year = (Time.new.year + 1)
		yr = Issue.create(year: next_year, title: "24")
		expect(yr.errors[:year]).to include("must be less than #{next_year}")
	end
  	
  it "is valid with year set to current year" do
  	this_year = Time.new.year
		yr = Issue.create(year: this_year , title: "24")
		expect(yr).to be_valid
	end
	
	it "can have many records to an issue description" do
		
		desc = Issuedescription.create(title: "May", full_title: "May", seq: 5)
		issue = desc.issues.create(title: "23",year: 2002)
		expect(issue).to be_valid
		issue = desc.issues.create(title: "24",year: 2002)
		expect(issue).to be_valid
	end
end
