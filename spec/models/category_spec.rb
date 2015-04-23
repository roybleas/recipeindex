# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  category   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Category, :type => :model do
  it "is valid with category " do
  	category = Category.new(category: 'biscuits and bars')
  	expect(category).to be_valid
  end
  
  it "is invalid without a category" do
  	category = Category.new(category: nil)
  	expect(category).to_not be_valid
  end 
end
