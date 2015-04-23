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
    	issue = create(:issue)
      get :show, id:issue
      expect(response).to have_http_status(:success)
    end
    
    it "assigns the requested issues to @issue" do
    	issue = create(:issue)
    	get :show, id:issue
    	expect(assigns(:issue)).to eq issue
    end
    
    it "assigns the requested issuedescription to @issuedesc" do
    	issue = create(:issue)
    	issuedesc = Issuedescription.find(issue.issuedescription_id)
    	get :show, id:issue
    	expect(assigns(:issuedesc)).to eq issuedesc
    end
    
    it "assigns the requested publications to @pub" do
    	issue = create(:issue)
    	pub = Publication.joins(:issues).where("issues.id = ?", issue.id).take
    	get :show, id:issue
    	expect(assigns(:pub)).to eq pub
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
    	
			issue = create(:issue)
			get :show, id: issue
			expect(response).to render_template :show
		end
  end

end
