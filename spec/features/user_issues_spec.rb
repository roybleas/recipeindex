 require 'rails_helper'
 
 feature 'update user' do
 	background do 
 		@user = create(:user)
 		visit root_path
		click_link 'Log in'
		fill_in "Name",							with: @user.name
		fill_in "Password",					with:	@user.password 
		click_button 'Log in'

 		@pub = create(:publication, title: :TestTitleOne)
 		isdesc = []
 		isdesc << create(:issuedescription_list_with_an_issue, publication_id: @pub.id, issue_count: 2, yr: 2001)
 		isdesc << create(:issuedescription_list_with_an_issue, publication_id: @pub.id, issue_count: 2, yr: 2001)
 		@issue = Issue.where("issues.issuedescription_id = ?",isdesc[1].id).take
 	end
	
	scenario 'add issue to owned list and view it' do
		visit root_path
		
		find("#usermenu").click_link :TestTitleOne
		expect(current_path).to eq  userissues_publication_path(@pub.id)
		
		find(:xpath,"//input[@value='#{@issue.id}']").set(true)
		click_button 'Save'
		
		expect(current_path).to eq issues_publication_path(@pub.id)
		expect(page).to have_content("Saved issue selection")
		expect(page).to have_xpath("//a[text()=#{@issue.no}]/following-sibling::span[@class='glyphicon glyphicon-ok']")
		
	end
	
	scenario 'remove issue from owned list' do
		create(:user_issue, user_id: @user.id, issue_id: @issue.id)
		
		visit root_path
		
		find("#issuesmenu").click_link :TestTitleOne
		expect(current_path).to eq issues_publication_path(@pub)
		expect(page).to have_xpath("//a[text()=#{@issue.no}]/following-sibling::span[@class='glyphicon glyphicon-ok']")
		
		find("#usermenu").click_link :TestTitleOne
		expect(current_path).to eq  userissues_publication_path(@pub.id)
		expect(find(:xpath,"//input[@value='#{@issue.id}']")).to be_checked
		
		find(:xpath,"//input[@value='#{@issue.id}']").set(false)
		click_button 'Save'
		
		expect(current_path).to eq issues_publication_path(@pub.id)
		expect(page).to have_content("Saved issue selection")
		expect(page).to_not have_xpath("//a[text()=#{@issue.no}]/following-sibling::span[@class='glyphicon glyphicon-ok']")
		expect(page).to have_xpath("//a[text()=#{@issue.no}]")
	end
end