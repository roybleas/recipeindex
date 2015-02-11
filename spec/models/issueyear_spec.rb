# == Schema Information
#
# Table name: issueyears
#
#  id             :integer          not null, primary key
#  year           :integer
#  publication_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

require 'rails_helper'

RSpec.describe Issueyear, :type => :model do
  it "is valid with a year" do
  	yr = Issueyear.new(year: 2001)
  	expect(yr).to be_valid
  end
  
  it "is invalid without a year" do
  	yr = Issueyear.create(year: nil)
  	expect(yr.errors[:year]).to include("can't be blank")
  end 
  
	it "can have many records to a publication" do
		pub = Publication.new(title: "Dish")
		yr = pub.issueyears.new(year: 2007)
		expect(yr).to be_valid
	end
	
	it "is invalid with a year less than 1990" do
		yr = Issueyear.create(year:1989)
		expect(yr.errors[:year]).to include("must be greater than 1989")
	end
  	
  it "is invalid with a year greater than this year" do
  	next_year = (Time.new.year + 1)
		yr = Issueyear.create(year: next_year )
		expect(yr.errors[:year]).to include("must be less than #{next_year}")
	end
  	
  it "is valid with year set to current year" do
  	this_year = Time.new.year
		yr = Issueyear.create(year: this_year)
		expect(yr).to be_valid
	end
end
