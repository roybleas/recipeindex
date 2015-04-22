# == Schema Information
#
# Table name: publications
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  published   :string(255)
#  description :string(255)
#

require 'rails_helper'
load(Rails.root.join( 'db', 'seeds', 'seedhelpers.rb'))

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
  	
  	it "is valid without a description" do
  		publication = Publication.new(title:	'A publication title without description', description: nil)
  		expect(publication).to be_valid
  	end
  	
  	it "is valid without a description" do
  		publication = Publication.new(title:	'A publication title without description', description: 'Has a description')
  		expect(publication).to be_valid
  	end
  	
  
  	it "can seed monthly issue descriptions excluding January" do
  		publication = Publication.new(title:	'A publication title')
  		publication.save
  		id = IssuedescriptionsGenerator.new(publication)
			id.gen_monthly(excludeJan = true)
			
			expect(publication.issuedescriptions.count).to eq 11
			
			pd =  publication.issuedescriptions.find_by_title("Feb")
			expect(pd).not_to be_nil
			expect(pd.issuemonths[0].monthindex).to eq 2
			
			pd =  publication.issuedescriptions.find_by_title("Nov")
			expect(pd).not_to be_nil
			expect(pd.issuemonths[0].monthindex).to eq 11
			
			expect(publication.issuedescriptions.find_by_title("Dec")).to be_nil
			
			pd =  publication.issuedescriptions.find_by_title("Dec-Jan")
			expect(pd).not_to be_nil
			expect(pd.issuemonths[0].monthindex).to eq 12
			expect(pd.issuemonths[1].monthindex).to eq 1
			
			
		end
		
		it "can seed monthly issue descriptions with January" do
  		publication = Publication.new(title:	'A publication title')
  		publication.save
  		id = IssuedescriptionsGenerator.new(publication)
			id.gen_monthly(excludeJan = false)
			
			expect(publication.issuedescriptions.count).to eq 12
			pd =  publication.issuedescriptions.find_by_title("Dec")
			expect(pd).not_to be_nil
			expect(pd.issuemonths[0].monthindex).to eq 12
			
		end
		
		it "can seed bi-monthly issue descriptions excluding January" do
  		publication = Publication.new(title:	'A publication title')
  		publication.save
  		id = IssuedescriptionsGenerator.new(publication)
			id.gen_bimonthly(excludeJan = true)
	
			expect(publication.issuedescriptions.count).to eq 6
		
			pd =  publication.issuedescriptions.find_by_title("Feb-Mar")
			expect(pd).not_to be_nil
			expect(pd.issuemonths[0].monthindex).to eq 2
			expect(pd.issuemonths[1].monthindex).to eq 3
			
			pd =  publication.issuedescriptions.find_by_title("Dec-Jan")
			expect(pd).not_to be_nil
			expect(pd.issuemonths[0].monthindex).to eq 12
			expect(pd.issuemonths[1].monthindex).to eq 1

			
		end
		
		it "can seed bi-monthly issue descriptions excluding January" do
  		publication = Publication.new(title:	'A publication title')
  		publication.save
  		id = IssuedescriptionsGenerator.new(publication)
			id.gen_bimonthly(excludeJan = false)
			
			expect(publication.issuedescriptions.count).to eq 6
			
			pd =  publication.issuedescriptions.find_by_title("Jan-Feb")
			expect(pd).not_to be_nil
			expect(pd.issuemonths[0].monthindex).to eq 1
			expect(pd.issuemonths[1].monthindex).to eq 2
			
			pd =  publication.issuedescriptions.find_by_title("Nov-Dec")
			expect(pd).not_to be_nil
			expect(pd.issuemonths[0].monthindex).to eq 11
			expect(pd.issuemonths[1].monthindex).to eq 12
		end
		
		it "can find correct issue description for a given month" do
  		publication1 = Publication.new(title:	'publication one')
  		publication1.save
  		id = IssuedescriptionsGenerator.new(publication1)
			id.gen_monthly(excludeJan = true)
			
			publication2 = Publication.new(title:	'publication two')
  		publication2.save
  		id2 = IssuedescriptionsGenerator.new(publication2)
			id2.gen_bimonthly(excludeJan = true)
			
			#fetch correct monthly issue 		
			mnth = 2
			d1 = Issuedescription.joins(:issuemonths, :publication).where(issuemonths: {monthindex: mnth}, publications: {title: publication1.title})
			expect(d1[0].title).to eq "Feb"
			mnth = 12
			d1 = Issuedescription.joins(:issuemonths, :publication).where(issuemonths: {monthindex: mnth}, publications: {title: publication1.title})
			expect(d1[0].title).to eq "Dec-Jan"
			mnth = 1
			d1 = Issuedescription.joins(:issuemonths, :publication).where(issuemonths: {monthindex: mnth}, publications: {title: publication1.title})
			expect(d1[0].title).to eq "Dec-Jan"
			
			#fetch correct bi monthly issue 		
			mnth = 2
			d2 = Issuedescription.joins(:issuemonths, :publication).where(issuemonths: {monthindex: mnth}, publications: {title: publication2.title})
			expect(d2[0].title).to eq "Feb-Mar"
			mnth = 3
			d2 = Issuedescription.joins(:issuemonths, :publication).where(issuemonths: {monthindex: mnth}, publications: {title: publication2.title})
			expect(d2[0].title).to eq "Feb-Mar"
			
			mnth = 12
			d2 = Issuedescription.joins(:issuemonths, :publication).where(issuemonths: {monthindex: mnth}, publications: {title: publication1.title})
			expect(d2[0].title).to eq "Dec-Jan"
			mnth = 1
			d2 = Issuedescription.joins(:issuemonths, :publication).where(issuemonths: {monthindex: mnth}, publications: {title: publication1.title})
			expect(d2[0].title).to eq "Dec-Jan"
		end
		
		it "can seed correct number of issues for a year" do
  		publication = Publication.new(title:	'A publication title')
  		publication.save
  		id = IssuedescriptionsGenerator.new(publication)
			id.gen_monthly(excludeJan = true)
			
			expect(publication.issuedescriptions.count).to eq 11
			
			desc = publication.issuedescriptions.find_by_title('Feb')
			IssueyearGenerator.new(publication, 2006).gen_issues_by_number(46) unless desc.issues.exists?(year:2006)
			 
			expect(publication.issues.count).to eq 11
		end
end
