 require 'rails_helper'
 
 feature 'Add user recipe' do
 	background do 
 		@user = create(:user)
 		visit root_path
		click_link 'Log in'
		fill_in "Name",							with: @user.name
		fill_in "Password",					with:	@user.password 
		click_button 'Log in'

		pub = create(:publication)
 		isdesc = create(:issuedescription, publication_id: pub.id)
 		mnth = Time.now.month
 		im = FactoryGirl.create(:issuemonth,monthindex: mnth, issuedescription_id: isdesc.id)
 		@issue = FactoryGirl.create(:issue_without_description, issuedescription_id: isdesc.id, year: 2014)
  	@recipe = create(:recipe, issue_id: @issue.id)
  		
 	end
 	scenario "select a recipe and add note" do
 		visit root_path
 		
 		click_link '2014'
 		expect(current_path).to eq issue_path(@issue)
 		page.click_link('', :href => recipe_path(@recipe))

		expect(current_path).to eq recipe_path(@recipe)
		expect(page).to have_link("Add Note")
		
		click_link("Add Note")
		expect(current_path).to eq new_recipe_userrecipe_path(@recipe)
		
		expect(page).to have_content(@recipe.title)
		
		choose("user_recipe_like_1")
		select('1', :from => 'user_recipe_rating')
		fill_in "Comment", 	with: "Some text about the recipe"
		
		click_button "Add Rating"
		
		expect(current_path).to eq recipe_path(@recipe)
		expect(page).to have_content("Your rating for this recipe has been saved.")
		expect(page).to have_css('span.like')
		expect(page).to have_css('span.glyphicon-heart')
		expect(page).to have_css('span.glyphicon-star')
		expect(page).to have_content("Some text about the recipe")
		
		
 	end
 	scenario "select a recipe and edit note" do
 		@userrecipe = create(:user_recipe, recipe_id: @recipe.id,user_id: @user.id)
 		
 		visit root_path
 		
 		click_link '2014'
 		expect(current_path).to eq issue_path(@issue)
 		page.click_link('', :href => recipe_path(@recipe))

		expect(current_path).to eq recipe_path(@recipe)
		expect(page).to have_link("Edit Note")
		
		click_link("Edit Note")
		expect(current_path).to eq edit_userrecipe_path(@userrecipe)
		
		expect(page).to have_content(@recipe.title)
		
		choose("user_recipe_like_-1")
		select('5', :from => 'user_recipe_rating')
		fill_in "Comment", 	with: "Changed my notes for this."
		
		click_button "Edit Rating"
		
		expect(current_path).to eq recipe_path(@recipe)
		expect(page).to have_content("Your rating for this recipe has been updated.")
		expect(page).to have_css('span.like')
		expect(page).to have_css('span.glyphicon-thumbs-down')
		expect(page).to have_css('span.glyphicon-star',:count => 5)
		expect(page).to have_content("Changed my notes for this.")

 	end
 	scenario "select a recipe and fail to edit note with invalid date" do
 		@userrecipe = create(:user_recipe, recipe_id: @recipe.id,user_id: @user.id)
 		
 		visit root_path
 		
 		click_link '2014'
 		expect(current_path).to eq issue_path(@issue)
 		page.click_link('', :href => recipe_path(@recipe))

		expect(current_path).to eq recipe_path(@recipe)
		expect(page).to have_link("Edit Note")
		
		click_link("Edit Note")
		expect(current_path).to eq edit_userrecipe_path(@userrecipe)
		
		expect(page).to have_content(@recipe.title)
		
		select('31', :from => 'user_recipe_lastused_3i')
		select('November', :from => 'user_recipe_lastused_2i')
		select('2015', :from => 'user_recipe_lastused_1i')
		
		click_button "Edit Rating"
		
		expect(current_path).to eq edit_userrecipe_path(@userrecipe)
		expect(page).to have_content("Invalid date selected.")
 	end
end