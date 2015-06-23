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
			3.times do
				@isdesc << create(:issuedescription_list_with_an_issue, publication_id: @pub.id, issue_count: 2, yr: 2001)
			end
			@user = create(:user)
		end
		it "returns http success" do	
 			get :userissues, id: @pub
      expect(response).to have_http_status(:success)
    end
 			
 		it "renders the :userissues template" do
			get :userissues, id: @pub
 			expect(response).to render_template :userissues
 		end
 		
 		it "assigns the requested publication to publication" do
 			get :userissues, id: @pub
 			expect(assigns(:publication)).to eq @pub
 		end
 		
 		it "assigns the requested issuedescriptions to issuedescription" do
 			get :userissues, id: @pub
 			expect(assigns(:issuedescriptions)).to eq @isdesc
 		end
 		
 		it "assigns requested issues to issues" do
 			get :userissues, id: @pub
 			issues_list = @isdesc.inject([]) { |issues_group, issuedesc| issues_group  +  issuedesc.issues }
 			expect(assigns(:issues).to_a).to match_array issues_list
 		end
 		
 		it "finds the issue linked to a user" do
 			allow(controller).to receive(:logged_in_user).and_return(true)
 			allow(controller).to receive(:current_user).and_return(@user)

 			issue = @isdesc[2].issues[0]
 			issue2 = @isdesc[1].issues[0]
 			userissue1 = create(:user_issue, user_id: @user.id, issue_id: issue.id)
 			
 			get :userissues,id: @pub
 			expect(assigns(:issues).find(issue.id).user_issues.first).to eq(userissue1)
 			expect(assigns(:issues).find(issue2.id).user_issues.first).to be_nil
 		end
 		
 		it "finds the issue linked to correct user when multiple users linked to the same issue" do
 			allow(controller).to receive(:logged_in_user).and_return(true)
 			allow(controller).to receive(:current_user).and_return(@user)

			user2 = create(:user, name: "Test user 2")
			
 			issue = @isdesc[2].issues[0]
 			userissue1 = create(:user_issue, user_id: @user.id, issue_id: issue.id)
 			
 			issue2 = @isdesc[2].issues[0]
 			userissue2 = create(:user_issue, user_id: user2.id, issue_id: issue.id)
 			
 			get :userissues,id: @pub
 			expect(assigns(:issues).find(issue.id).user_issues.first).to eq(userissue1)
 			expect(assigns(:issues).find(issue.id).user_issues.last).to eq(userissue1)
 			
 			allow(controller).to receive(:current_user).and_return(user2)
 			get :userissues,id: @pub
 			expect(assigns(:issues).find(issue.id).user_issues.first).to eq(userissue2)
 		end
 	end
end