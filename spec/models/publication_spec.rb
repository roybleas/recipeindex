require 'rails_helper'

RSpec.describe Publication, :type => :model do
  
  	it "is valid with a title" do
  		publication = Publication.new(title:	'A publication title')
  		expect(publication).to be_valid
  	end
  	
  	it "is invalid without a title" do
  		publication = Publication.new(title: nil)
  		publication.valid?
  		expect(publication.errors[:title]).to include("can't be blank")
  	end
  	
  	it "is invalid with a duplicate title" do
  		publication = Publication.create(title:	'A duplicate title')
  		expect(publication).to be_valid
  		publication = Publication.create(title:	'A duplicate title')
  		publication.valid?
  		expect(publication.errors[:title]).to include("has already been taken")
  		
  	end
  	
  	it "is valid without a published frequency" do
  		publication = Publication.new(title:	'A publication title without frequency', published: nil)
  		expect(publication).to be_valid
  	end
  	
  	it "is valid with a published frequency" do
  		publication = Publication.new(title:	'A publication title with frequency', published: 'Monthly')
  		expect(publication).to be_valid
  	end
  	
  	
end
