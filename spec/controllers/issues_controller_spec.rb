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
    	pub = Publication.find(issue.id)
    	get :show, id:issue
    	expect(assigns(:pub)).to eq pub
    end
    
    it "assigns the requested years to @years" do
    
    	issue = create(:issue)
    	# find the publication created
    	pub = Publication.find(issue.id)
    	# use the publication to create several issue records for different years
    	isdesc = FactoryGirl.create(:issuedescription_with_years, publication: pub, issues_count: 2)
    	# create an issue record for the same year ar first but different issuedescription to ensure distinct
    	is2 = FactoryGirl.create(:issue, issuedescription: isdesc, year: issue.year)
			
    	get :show, id:issue
    	expect(assigns(:years).count).to eq (Issue.select(:year).distinct.count)
    	
    end
    
    it "renders the :show template" do
    	
			issue = create(:issue)
			get :show, id: issue
			expect(response).to render_template :show
		end
  end

end
