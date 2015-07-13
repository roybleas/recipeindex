require 'rails_helper'

RSpec.describe PublicationsController, :type => :controller do
	
	before :each do
 		adminuser =  create(:admin_user)
 		session[:user_id] = adminuser.id
 	end


	describe 'GET #edit' do
		
		it "returns http success" do
			pub = create(:publication)
 			get :edit, id: pub
      expect(response).to have_http_status(:success)
    end
    
 		it "assigns the requested publication to publication" do
 			pub = create(:publication)
 			get :edit, id: pub
 			expect(assigns(:publication)).to eq pub
 		end
 			
 		it "renders the :edit template" do
 			pub = create(:publication)
			get :edit, id: pub
 			expect(response).to render_template :edit
 		end
 		
 		it "redirects to log in when not logged in" do
 			session[:user_id] = nil
 			pub = create(:publication)
			get :edit, id: pub
 			expect(response).to redirect_to login_url
 		end
 		
 		it "redirects to root when user is not admin" do
 			user =  create(:user)
 			session[:user_id] = user.id
 			pub = create(:publication)
			get :edit, id: pub
 			expect(response).to redirect_to root_url
 		end
 		
 	end
 	
 	describe "Patch update" do
 		
 		
 		context "valid attributes" do
 		
 			it "locates the requested publication" do
 				pub = create(:publication)
 				patch :update, id: pub, publication: attributes_for(:publication)
				expect(assigns(:publication)).to eq(pub)
			end
 			
 			it "changes the publication values" do
 				pub = create(:publication)
 				patch :update, id: pub, 
 						publication: attributes_for(:publication,
 							title:  "Delicious",
   						published: "Annually",
   						description: "ABC new food magazine.")
 				pub.reload
 				expect(pub.title).to eq('Delicious')
 				expect(pub.published).to eq('Annually')
 				expect(pub.description).to eq('ABC new food magazine.')
 			end
 			
 			it "redirects to updated publication" do
 				pub = create(:publication)
 				patch :update, id: pub, publication: attributes_for(:publication)
				expect(response).to redirect_to admin_pages_home_url
			end
 		end
	end

	describe 'issues by publication' do
		
		before(:each) do
			@pub = create(:publication)
			@isdesc = []
			3.times do
				@isdesc << create(:issuedescription_list_with_an_issue, publication_id: @pub.id, issue_count: 2, yr: 2001)
			end
		end
		
		it "returns http success" do
			
 			get :issues, id: @pub
      expect(response).to have_http_status(:success)
    end
 			
 		it "renders the :issues template" do
			get :issues, id: @pub
 			expect(response).to render_template :issues
 		end
 		
 		it "assigns the requested publication to publication" do
 			get :issues, id: @pub
 			expect(assigns(:publication)).to eq @pub
 		end
 		
 		it "assigns the requested issuedescriptions to issuedescription" do
 			get :issues, id: @pub
 			expect(assigns(:issuedescriptions)).to eq @isdesc
 		end
 		
 		it "assigns the requested issues to issues" do
 			get :issues, id: @pub
 			issues_list = @isdesc.inject([]) { |issues_group, issuedesc| issues_group  +  issuedesc.issues }
 			expect(assigns(:issues).to_a).to match_array issues_list
 		end
 		
 		it "assigns the requested issue descriptions in the correct sequence" do
 			pub2 = create(:publication)
			isdesc2 = []
			isdesc2 << create(:issuedescription_list, publication_id: pub2.id, seq: 3)
			isdesc2 << create(:issuedescription_list, publication_id: pub2.id, seq: 1)
			isdesc2 << create(:issuedescription_list, publication_id: pub2.id, seq: 2)
 			issuedesc_list = [isdesc2[1], isdesc2[2] , isdesc2[0]]
 			get :issues, id: pub2
 			expect(assigns(:issuedescriptions)).to eq issuedesc_list
 		end
 		
 		it "assigns the requested issues in the correct issuedescription and year sequence" do
 			pub2 = create(:publication)
			isdesc2 = []
			isdesc2 << create(:issuedescription_list_with_an_issue, publication_id: pub2.id, seq: 3, issue_count: 2, yr: 2001)
			isdesc2 << create(:issuedescription_list_with_an_issue, publication_id: pub2.id, seq: 1, issue_count: 2, yr: 2001)
			isdesc2 << create(:issuedescription_list_with_an_issue, publication_id: pub2.id, seq: 2, issue_count: 2, yr: 2001)
 			issuedesc_list = [isdesc2[1], isdesc2[2] , isdesc2[0]] 			 			
 			issues_list0 = issuedesc_list.inject([]) { |issues_group, issuedesc| issues_group  <<  issuedesc.issues.sort_by(&:no)[0] }
 			issues_list1 = issuedesc_list.inject([]) { |issues_group, issuedesc| issues_group  <<  issuedesc.issues.sort_by(&:no)[1] }
 			issues_list = issues_list0 + issues_list1
 			
 			get :issues, id: pub2
 			expect(assigns(:issues).to_a).to eq issues_list
 		end
 		
 		it "redirects to root if publication id parameter not found" do
 			get :issues, id: @pub.id + 1
 			expect(response).to redirect_to :root
 		end
 			
	end
 	
 	describe 'issues by user' do
 		
 		before(:each) do
			@pub = create(:publication)
			@isdesc = []
		end
 		
 		context 'render form for publication parameter' do
 			before(:each) do
				get :userissues, id: @pub  	
			end
			
			it {expect(response).to have_http_status(:success)}
			it {expect(response).to render_template :userissues}
			it {expect(assigns(:publication)).to eq @pub}
			
 		end
 		
 		context 'when publication does not exit' do
 			it 'redirects to root' do
 				get :userissues, id: @pub.id + 2
 				expect(response).to redirect_to :root
 			end
 		end 
 		
 		context 'when issuedescriptions exist' do
 			before(:each) do
 				@isdesc << create(:issuedescription_list_with_an_issue, publication_id: @pub.id, issue_count: 2, yr: 2001)
 			end
 			
 			it "assigns to @issuedescriptions" do
 				get :userissues, id: @pub  	
 				expect(assigns(:issuedescriptions)).to_not be_empty
 				expect(assigns(:issuedescriptions)).to eq @isdesc
 			end
 			
 			it "only assigns issue descriptions for current publication" do
 				pub2 = create(:publication, title: "test publication two")
 				create(:issuedescription_list_with_an_issue, publication_id: pub2.id, issue_count: 6, yr: 2001)
 				get :userissues, id: @pub  	
 				expect(assigns(:issuedescriptions)).to eq @isdesc
 			end
 		end
 		
 		context "when issues exist" do 			
 			it "finds the issues" do	
 				@isdesc << create(:issuedescription_list_with_an_issue, publication_id: @pub.id, issue_count: 2, yr: 2001)
 				get :userissues, id: @pub  	
 				issues_list = @isdesc.inject([]) { |issues_group, issuedesc| issues_group  +  issuedesc.issues }
 				expect(assigns(:issues).to_a).to match_array issues_list
 			end
 		end
 		
 		context "when user logged in " do
 			before(:each) do
 				@user = create(:user)
 				allow(controller).to receive(:logged_in_user).and_return(true)
 				allow(controller).to receive(:current_user).and_return(@user)
 				
 				@isdesc << create(:issuedescription_list_with_an_issue, publication_id: @pub.id, issue_count: 2, yr: 2001)
 				@issue = @isdesc[0].issues[0]
 				@userissue1 = create(:user_issue, user_id: @user.id, issue_id: @issue.id)
 			end
 			
 			it "fetches issue with current user id" do
				get :userissues,id: @pub 		
				
			  issue = assigns(:issues).find(@issue.id)
 				expect(issue.user_id).to eq(@user.id)
 			end
 			
 			it "does not fetch user_id for other issue" do
 				issue_without_user = @isdesc[0].issues[1]
 				get :userissues,id: @pub 
 				
 				issue = assigns(:issues).find(issue_without_user.id)
 				expect(issue.user_id).to be_nil
 			end
 			
 			it "does not fetch other user_id when linked to same issue" do
 				user2 = create(:user, name: "Test user 2")
 				userissue2 = create(:user_issue, user_id: user2.id, issue_id: @issue.id)				
 				get :userissues,id: @pub 
 				
				issue = assigns(:issues).find(@issue.id)
 				expect(issue.user_id).to eq(@user.id)
 			end
 		end
 	end
 	
 	describe 'patch user issues ' do
 		before(:each) do
			@pub = create(:publication)
		end
		
 		context 'redirection' do
 			it ' redirects back to user issues when nothing changed' do
 				patch :userissuesupdate, id: @pub.id 
 				expect(response).to redirect_to :action => :userissues, :id => @pub.id
 			end

 			it ' redirects to issues when updated' do
 				isdesc =  create(:issuedescription_list_with_an_issue, publication_id: @pub.id, issue_count: 2, yr: 2001)
 				issue = isdesc.issues.first
 				userissue_ids = [issue.id]
 				patch :userissuesupdate, id: @pub.id , userissue: userissue_ids
 				expect(response).to redirect_to :action => :issues, :id => @pub.id
 			end
 		end 
 		
 		context 'updating ' do
 			before(:each) do
 				@isdesc = []
 				@isdesc << create(:issuedescription_list_with_an_issue, publication_id: @pub.id, issue_count: 3, yr: 2001)
 				@isdesc << create(:issuedescription_list_with_an_issue, publication_id: @pub.id, issue_count: 3, yr: 2002)
 				@issue = @isdesc[1].issues.first
 				@userissue_ids = [@issue.id]
 				@user = create(:user)
 				allow(controller).to receive(:current_user).and_return(@user)
 			end
 			
 			it "creates a new user issue" do	
 				patch :userissuesupdate, id: @pub.id , userissue: @userissue_ids
 				expect(UserIssue.find_by user_id: @user.id, issue_id: @issue.id).to_not be_nil
 			end
 			
 			it "keeps existing user issue" do
 				userissue = create(:user_issue, user_id: @user.id, issue_id: @issue.id)				
 				
 				patch :userissuesupdate, id: @pub.id , userissue: @userissue_ids
 				expect(UserIssue.find_by user_id: @user.id, issue_id: @issue.id).to_not be_nil
 			end

 			it "removes existing user issue" do
 				userissue = create(:user_issue, user_id: @user.id, issue_id: @issue.id)				
 				empty_userissue_ids = []
 				patch :userissuesupdate, id: @pub.id , userissue: empty_userissue_ids
 				expect(UserIssue.find_by user_id: @user.id, issue_id: @issue.id).to be_nil
 			end
 			
 			it "adds one removes one and keeps one user issue" do
 				
 				issue2 = @isdesc[0].issues.last
 				userissue2 = create(:user_issue, user_id: @user.id, issue_id: issue2.id)				
 				issue3 = @isdesc[0].issues.first
 				userissue3 = create(:user_issue, user_id: @user.id, issue_id: issue3.id)				
 				
 				@userissue_ids << issue3.id
 				
 				expect(UserIssue.find_by user_id: @user.id, issue_id: @issue.id).to be_nil
 				expect(UserIssue.find_by user_id: @user.id, issue_id: issue2.id).to_not be_nil
 				expect(UserIssue.find_by user_id: @user.id, issue_id: issue3.id).to_not be_nil
 				
 				patch :userissuesupdate, id: @pub.id , userissue: @userissue_ids
 				
 				#add
				expect(UserIssue.find_by user_id: @user.id, issue_id: @issue.id).to_not be_nil
 				#delete
 				expect(UserIssue.find_by user_id: @user.id, issue_id: issue2.id).to be_nil
 				#keep
 				expect(UserIssue.find_by user_id: @user.id, issue_id: issue3.id).to_not be_nil

 			end


 		end
 	end
end