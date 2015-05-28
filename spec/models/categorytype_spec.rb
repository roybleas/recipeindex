# == Schema Information
#
# Table name: categorytypes
#
#  id         :integer          not null, primary key
#  code       :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Categorytype, :type => :model do
  it "is valid with a code and name" do
  	cattype = create(:categorytype)
  	expect(cattype).to be_valid
  end
  
  it "is invalid without a code" do
  	cattype = build(:categorytype, code: nil)
  	cattype.valid?
  	expect(cattype.errors[:code]).to include("can't be blank")
  end 
  
  it "is invalid without a name" do
  	cattype = build(:categorytype, name:nil)
  	cattype.valid?
  	expect(cattype.errors[:name]).to include("can't be blank")
  end 
  
  it "is invalid with a duplicate code" do
  	cattype = create(:categorytype)
  	expect(cattype).to be_valid
  	cattype2 = build(:categorytype, code: cattype.code)
  	cattype2.valid?
  	expect(cattype2.errors[:code]).to include("has already been taken")
  end 
  
  it "is invalid with a duplicate name" do
  	cattype = create(:categorytype)
  	expect(cattype).to be_valid
  	cattype2 = build(:categorytype, name: cattype.name)
  	cattype2.valid?
  	expect(cattype2.errors[:name]).to include("has already been taken")
  end 
end
