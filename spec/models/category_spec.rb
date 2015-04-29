# == Schema Information
#
# Table name: categories
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  seq             :integer
#  categorytype_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

require 'rails_helper'

RSpec.describe Category, :type => :model do
	before :each do
 		@cattype = Categorytype.create(name: "Ingredient", code: "I")
 	end
 	
  it "is valid with a name and seq" do
  	
  	category = @cattype.categories.new(name: "a category", seq: 1)
  	expect(category).to be_valid
  end
  
  it "is valid with a name" do
  	category = @cattype.categories.new(name: "a category", seq: nil)
  	expect(category).to be_valid
  end
  
  it "is invalid without a name" do
  	category = @cattype.categories.new(name: nil, seq: nil)
  	category.valid?
  	expect(category.errors[:name]).to include("can't be blank")
  end
  
  it "is invalid with a duplicate name" do
		category = @cattype.categories.create(name: "a category", seq: 1)
		expect(category).to be_valid
		category = Category.create(name: "a category", seq: 2)
		category.valid?
		expect(category.errors[:name]).to include("has already been taken")
  end
  
  it "can have many records to a category type" do
		
		cattype = Categorytype.create(code: "A", name: "a category type name")
		category = cattype.categories.new(name: "first category")
		expect(category).to be_valid
		category = cattype.categories.new(name: "second category")
		expect(category).to be_valid
	end
	
	
end
