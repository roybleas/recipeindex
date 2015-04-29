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
  	cattype = Categorytype.new(code: "A", name: "a category type name")
  	expect(cattype).to be_valid
  end
  
  it "is invalid without a code" do
  	cattype = Categorytype.new(code: nil, name: "a category type name")
  	cattype.valid?
  	expect(cattype.errors[:code]).to include("can't be blank")
  end 
  
  it "is invalid without a name" do
  	cattype = Categorytype.new(code: "A", name: nil)
  	cattype.valid?
  	expect(cattype.errors[:name]).to include("can't be blank")
  end 
  
  it "is invalid with a duplicate code" do
  	cattype = Categorytype.create(code: "A", name: "a category type name")
  	expect(cattype).to be_valid
  	cattype = Categorytype.new(code: "A", name: "another category type name")
  	cattype.valid?
  	expect(cattype.errors[:code]).to include("has already been taken")
  end 
  
  it "is invalid with a duplicate code" do
  	cattype = Categorytype.create(code: "A", name: "a category type name")
  	expect(cattype).to be_valid
  	cattype = Categorytype.new(code: "B", name: "a category type name")
  	cattype.valid?
  	expect(cattype.errors[:name]).to include("has already been taken")
  end 
end
