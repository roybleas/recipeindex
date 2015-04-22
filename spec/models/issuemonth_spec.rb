# == Schema Information
#
# Table name: issuemonths
#
#  id                  :integer          not null, primary key
#  monthindex          :integer
#  issuedescription_id :integer
#  created_at          :datetime
#  updated_at          :datetime
#

require 'rails_helper'

RSpec.describe Issuemonth, :type => :model do
 	it "is valid with a month index" do
  	mth = Issuemonth.new(monthindex: 1)
  	expect(mth).to be_valid
  end
  
  it "is invalid without a month index" do
  	mth = Issuemonth.create(monthindex: nil)
  	expect(mth.errors[:monthindex]).to include("can't be blank")
  end 
  
	it "can have many records to an Issuedescription" do
		desc = Issuedescription.new(title: "Feb")
		mth = desc.issuemonths.new(monthindex: 2)
		expect(mth).to be_valid
		desc = Issuedescription.new(title: "Dec-Jan")
		mth = desc.issuemonths.new(monthindex: 12)
		expect(mth).to be_valid
		mth = desc.issuemonths.new(monthindex: 1)
		expect(mth).to be_valid
	end
	
	it "is invalid with a monthindex less than 1" do
		mth = Issuemonth.create(monthindex: 0)
		expect(mth.errors[:monthindex]).to include("must be greater than 0")
	end
  
  it "is invalid with a monthindex greater than 12" do
		mth = Issuemonth.create(monthindex:13)
		expect(mth.errors[:monthindex]).to include("must be less than 13")
	end
end
