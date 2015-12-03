# == Schema Information
#
# Table name: issuedescriptions
#
#  id             :integer          not null, primary key
#  title          :string
#  full_title     :string
#  seq            :integer
#  publication_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

require 'rails_helper'

RSpec.describe Issuedescription, :type => :model do
  it "is valid with title,full title and sequence number" do
  	desc = Issuedescription.new(title: 'Feb', full_title: 'February', seq: 1)
  	expect(desc).to be_valid
  end
  it "is invalid without title" do
  	desc = Issuedescription.new(title: nil, full_title: 'February', seq: 1)
  	desc.valid?
  	expect(desc.errors[:title]).to include("can't be blank")
  end
  it "is invalid without a full title" do
  	desc = Issuedescription.new(title: 'Feb', full_title: nil, seq: 1)
  	desc.valid?
  	expect(desc.errors[:full_title]).to include("can't be blank")
  end
  
  it "is invalid without a sequence number" do
  	desc = Issuedescription.new(title: 'Feb', full_title: 'February', seq: nil)
  	desc.valid?
  	expect(desc.errors[:seq]).to include("can't be blank")
  end
  
  it "is valid with a publication key" do
  	desc =  Publication.new(title: 'Dish').issuedescriptions.new(title: 'Mar', full_title: 'March', seq: 2)
  	expect(desc).to be_valid
  end
  
  it "is valid with a publication key2" do
  	pub = Publication.new(title: "Dish")
  	desc2 =  pub.issuedescriptions.new(title: 'Apr', full_title: 'April', seq: 3)
  	expect(desc2).to be_valid
  end
end
