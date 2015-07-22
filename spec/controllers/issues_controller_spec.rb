require 'rails_helper'

RSpec.describe IssuesController, :type => :controller do

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
   
   it "renders the :index template" do
			get :index
			expect(response).to render_template :index
		end
  end

  describe "GET show" do
    it "returns http success" do
    	issue = create(:issue, year: 1990)
      get :show, id:issue
      expect(response).to have_http_status(:success)
    end
    
    it "assigns the requested issues to @issue" do
    	issue = create(:issue, year: 1991)
    	get :show, id:issue
    	expect(assigns(:issue)).to eq issue
    end
    
    it "assigns the requested issuedescription to @issuedesc" do
    	issue = create(:issue, year: 1992)
    	issuedesc = Issuedescription.find(issue.issuedescription_id)
    	get :show, id:issue
    	expect(assigns(:issuedesc)).to eq issuedesc
    end
    
    it "assigns the requested publications to @pub" do
    	issue = create(:issue, year: 1993)
    	pub = Publication.joins(:issues).where("issues.id = ?", issue.id).take
    	get :show, id:issue
    	expect(assigns(:pub)).to eq pub
    end
    
    it "redirects to root when id not found" do
    	issue = create(:issue, year: 1994)
    	get :show, id: (issue.id) + 1
    	expect(response).to redirect_to :root
    end
    
    it "assigns the previous year and next year to null when only one issue year" do
    
    	issue = FactoryGirl.create(:issue, year: 2005)	   	
			
    	get :show, id:issue
    	expect(assigns(:year_before)).to eq nil
    	expect(assigns(:year_after)).to eq nil
    	
    end
    
    it "assigns the previous year to null and next year to following year" do
    
    	issue = FactoryGirl.create(:issue, year: 2010)
    	# find the publication created
    	pub = Publication.joins(:issues).where("issues.id = ?", issue.id).take
    	# use the publication to create several issue records for different years
    	isdesc = FactoryGirl.create(:issuedescription_with_years, publication: pub, issues_count: 2)
    	issue = isdesc.issues.first
			
    	get :show, id:issue
    	expect(assigns(:year_before)).to eq nil
    	expect(assigns(:year_after).year).to eq (issue.year + 1)
    	
    end

    it "assigns the previous year to earlier year and next year to null when latest year" do
    
    	issue = FactoryGirl.create(:issue, year: 2010)
    	# find the publication created
    	pub = Publication.joins(:issues).where("issues.id = ?", issue.id).take
    	# use the publication to create several issue records for different years
    	isdesc = FactoryGirl.create(:issuedescription_with_years, publication: pub, issues_count: 2)
    	issue = isdesc.issues.last
			
    	get :show, id:issue
    	expect(assigns(:year_before).year).to eq (issue.year - 1)
    	expect(assigns(:year_after)).to eq nil
    end
    
    it "assigns the previous year to earlier year and next year to following year when not first or latest year" do
    
    	issue = FactoryGirl.create(:issue, year: 2010)
    	# find the publication created
    	pub = Publication.joins(:issues).where("issues.id = ?", issue.id).take
    	# use the publication to create several issue records for different years
    	isdesc = FactoryGirl.create(:issuedescription_with_years, publication: pub, issues_count: 5)
    	issue = isdesc.issues[2]
			
    	get :show, id:issue
    	expect(assigns(:year_before).year).to eq (issue.year - 1)
    	expect(assigns(:year_after).year).to eq (issue.year + 1)
    end

		it "assigns previous_issue from previous issuedescription sequence " do
			pub = FactoryGirl.create(:publication, title: "Test sequence")
			lastseq = 4
			firstyear = 2004
			lastyear = firstyear + 2
			(1...lastseq).each { |s|
				isdesc = FactoryGirl.create(:issuedescription, publication: pub, seq: s)
				(firstyear...lastyear).each {|yr| FactoryGirl.create(:issue, issuedescription: isdesc, year: yr) }
    	}
    	isdescs = Issuedescription.where("publication_id = ?",pub.id).order(seq: :asc)
    	
    	issue = isdescs[0].issues.first
    	issue_prev = isdescs[-1].issues.where(year: issue.year).take
    	issue_next = isdescs[1].issues.where(year: issue.year).take
    	
    	get :show, id:issue
    	
    	expect(assigns(:previous_issuedescription).id).to eq issue_prev.id
    	expect(assigns(:next_issuedescription).id).to eq issue_next.id
    	
    	
    	issue = isdescs[-1].issues.last 
    	
    	issue_prev = isdescs[-2].issues.where(year: issue.year).take
    	issue_next = isdescs[0].issues.where(year: issue.year).take
    	
    	get :show, id:issue
    	
    	expect(assigns(:previous_issuedescription).id).to eq issue_prev.id
    	expect(assigns(:next_issuedescription).id).to eq issue_next.id
    	
			issue = isdescs[1].issues.where(year: (firstyear + 1)).take
    	
    	issue_prev = isdescs[0].issues.where(year: issue.year).take
    	issue_next = isdescs[2].issues.where(year: issue.year).take
    	
    	get :show, id:issue
    	
    	expect(assigns(:previous_issuedescription).id).to eq issue_prev.id
    	expect(assigns(:next_issuedescription).id).to eq issue_next.id
    	
    end
    	
    it "renders the :show template" do
    	
			issue = create(:issue, year: 2001)
			get :show, id: issue
			expect(response).to render_template :show
		end
  end
  
  describe "GET show years" do
    it "returns http success" do
      issue = create(:issue, year: 2001)
      get :years, id:issue
      expect(response).to have_http_status(:success)
    end
    
    it "assigns the requested publications to @pub" do
    	issue = create(:issue, year: 2001)
    	pub = Publication.joins(:issues).where("issues.id = ?", issue.id).take
    	get :years, id:issue
    	expect(assigns(:pub)).to eq pub
    end
    
    it "assigns the an issue record to @yrs" do
    	issue = create(:issue, year: 2001)
    	
    	get :years, id:issue
    	expect(assigns(:years).first.year).to eq issue.year
    end
    
    it "assigns multiple issue record to @yrs in ascending order" do
    	
    	# important need to set id as error in SQL not picked up as issuedescription.id happens 
    	# to be the same as issue.id
    	issuedesc = create(:issuedescription, id: 21)
    	firstyear = 2004
			lastyear = firstyear + 3
			    	
    	lastyear.downto(firstyear) {|yr| create(:issue, issuedescription: issuedesc, year: yr) }
    	issue = issuedesc.issues.take
    	
    	get :years, id:issue
    	expect(assigns(:years).first.year).to eq firstyear
    	expect(assigns(:years).last.year).to eq lastyear
    end
    
    it "renders the :years template" do
    	
			issue = create(:issue, year: 1996)
			get :years, id: issue
			expect(response).to render_template :years
		end
  end
  
   describe "GET show descriptions" do
    it "returns http success" do
      issue = create(:issue, year: 2001)
      get :descriptions, id:issue
      expect(response).to have_http_status(:success)
    end
    
    it "assigns the requested publications to @pub" do
    	issue = create(:issue, year: 2001)
    	pub = Publication.joins(:issues).where("issues.id = ?", issue.id).take
    	get :descriptions, id:issue
    	expect(assigns(:pub)).to eq pub
    end
    
    
    it "assigns the issuedescription records to @issuedescs in ascending order seq for an issue" do
    	
    	# important need to set id as error in SQL not picked up as issuedescription.id happens 
    	# to be the same as issue.id
    	
    	pub = create(:publication, title: 'Test Publication 1' )
    	pub2 = create(:publication, title: 'Test Publication 2' )
    	year1 = 2002
    	year2 = 2004
    	firstseq = 1
    	lastseq = firstseq + 4
    	
    	issuedesc = create(:issuedescription, id: 30,publication: pub, seq: firstseq)
    	
    	create(:issue_without_description, issuedescription: issuedesc, year: year1)
    	#the following issue is passed to controller
    	issue = create(:issue_without_description, issuedescription: issuedesc, year: year2)
    	
    	#create a set of issue descriptions with a couple of issues each
			((firstseq+1)..lastseq).each { |s|
				issuedesc = create(:issuedescription, id: (issuedesc.id + s), publication: pub, seq: s)
				create(:issue_without_description, issuedescription: issuedesc, year: year1)
				create(:issue_without_description, issuedescription: issuedesc, year: year2)
			}
    	get :descriptions, id:issue
    	
    	expect(assigns(:descriptions).first.seq).to eq firstseq
    	expect(assigns(:descriptions).last.seq).to eq lastseq
    	expect(assigns(:descriptions).first.issues.first.year).to eq year2
    	expect(assigns(:descriptions).last.issues.first.year).to eq year2
    end
    
    it "assigns the issuedescription records for a single publication to @issuedescs " do
    	
    	# important need to set id as error in SQL not picked up as issuedescription.id happens 
    	# to be the same as issue.id
    	
    	pub = create(:publication, title: 'Test Publication 1' )
    	pub2 = create(:publication, title: 'Test Publication 2' )
    	year1 = 2006
    	year2 = 2007
    	firstseq = 1
    	lastseq = firstseq + 2
    	issuedesc = create(:issuedescription, id: 40,publication: pub2, seq: firstseq)
    	
    	create(:issue_without_description, issuedescription: issuedesc, year: year1)
    	#the following issue is passed to controller
    	issue = create(:issue_without_description, issuedescription: issuedesc, year: year2)
    	
    	#create a set of issue descriptions with a couple of issues each
			((firstseq+1)..lastseq).each { |s|
				issuedesc = create(:issuedescription, id: (issuedesc.id + s), publication: pub2, seq: s)
				create(:issue_without_description, issuedescription: issuedesc, year: year1)
				create(:issue_without_description, issuedescription: issuedesc, year: year2)
			}
			
			firstseq2 = lastseq
    	lastseq2 = firstseq2 + 2
			 #create a second set of issue descriptions for a different publication
			((firstseq2)..lastseq2).each { |s|
				issuedesc = create(:issuedescription, id: (issuedesc.id + s), publication: pub, seq: s)
				create(:issue_without_description, issuedescription: issuedesc, year: year1)
				create(:issue_without_description, issuedescription: issuedesc, year: year2)
			}
			issuedesc = create(:issuedescription,publication: pub2, seq: lastseq2 +1)
			create(:issue_without_description, issuedescription: issuedesc, year: year2)
			
    	get :descriptions, id:issue
    	
    	expect(assigns(:descriptions).first.seq).to eq firstseq
    	expect(assigns(:descriptions).last.seq).to eq lastseq2 + 1
    	expect(assigns(:descriptions).last.publication_id).to eq pub2.id
    end
    
    
    it "renders the :descriptions template" do
    	
			issue = create(:issue, year:2001)
			get :descriptions, id: issue
			expect(response).to render_template :descriptions
		end
  end

end
