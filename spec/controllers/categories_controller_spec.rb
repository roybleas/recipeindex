require 'rails_helper'

RSpec.describe CategoriesController, :type => :controller do
	
  context "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
    it "renders the index template" do
			get :index
 			expect(response).to render_template :index
 		end
 		it "renders the index template via letter" do
			get :byletter, letter:'y'
 			expect(response).to render_template :index
 		end
  end
   
  context 'without params[:letter]' do
		it "populates a default array of categories a-b" do
			
			cattype = create(:categorytype, code: 'I')
			apple = create(:category, name: 'apple', :categorytype => cattype )
			zucchini = create(:category, name: 'zucchini' , :categorytype => cattype)
			 
			get :index					 
			expect(assigns(:categories)).to match_array([apple])
		end
	 end
	 
	 context 'with params[:letter]' do
 		before(:each) do
 			cattype = create(:categorytype, code: 'I')
 			
 			@apple = create(:category, name: 'apple', :categorytype => cattype )
			@zucchini = create(:category, name: 'zucchini' , :categorytype => cattype)
			@banana = create(:category, name: 'banana', :categorytype => cattype )
			@pear = create(:category, name: 'pears', :categorytype => cattype )
			@egg = create(:category, name: 'eggs', :categorytype => cattype )
 		end
 					
		it "populates an array a-b with the letter a or b" do
 			get :byletter, letter:'a'	 
			expect(assigns(:categories)).to match_array([@apple, @banana])
			
			get :byletter, letter:'b'	 
			expect(assigns(:categories)).to match_array([@apple, @banana])
		end
		
		it "creates an empty array for range c-d with the letter c" do
 			get :byletter, letter:'c'			 
			expect(assigns(:categories)).to be_empty
		end
		
		it "populates an array n-p with the letter o" do
 			get :byletter, letter:'o'	 
			expect(assigns(:categories)).to match_array([@pear])
		end

		it "populates an array q-z with the uppercase letter z" do
 			get :byletter, letter:'Z'	 
			expect(assigns(:categories)).to match_array([@zucchini])
		end

		it "populates an array e-m with the letter m and category S" do
			cattype = create(:categorytype, code: 'S')
			marinade = create(:category, name: 'marinades', :categorytype => cattype)

			get :byletter, letter:'m'
			expect(assigns(:categories)).to match_array([@egg,marinade])
		end
		
		it "creates a default array for range a-b with non-letter " do
	 		get :byletter, letter:'2'
	 		expect(assigns(:categories)).to match_array([@apple, @banana])
		end
	end
		
  context "GET show" do
  	before(:each) do
  		cattype = create(:categorytype)
  		@category = create(:category, categorytype_id: cattype.id)
  		@issue_description = create(:issuedescription)
    	@issue = create(:issue, issuedescription_id: @issue_description.id, year: 2014)
    	@recipe = create(:recipe, issue_id: @issue.id)
    	@category_recipe = create(:category_recipe, category_id: @category.id, recipe_id: @recipe.id)
    
  	end
  	
    it "returns http success" do
      get :show, id: @category
      expect(response).to have_http_status(:success)
    end
    
    it "assigns the requested category to @category" do
    	get :show, id:@category
    	expect(assigns(:category)).to eq @category
    end
    it "assigns the requested recipe to @recipe" do
    	get :show, id:@category
    	expect(assigns(:recipes)).to match_array(@recipe)
    end
    context "logged in" do
    	before(:each) do
    		@user = create(:user)
    		session[:user_id] = @user.id
    	end
    	it "assigns the requested recipe to @recipe without a user issue" do
    		get :show, id:@category
    		expect(assigns(:recipes)).to match_array(@recipe)
    		expect(assigns(:recipes)[0].year).to eq 2014
    		expect(assigns(:recipes)[0].desc).to eq @issue_description.title
    		expect(assigns(:recipes)[0].pub).to eq Publication.find(@issue_description.publication_id).title
    		expect(assigns(:recipes)[0].user_owned).to be_nil
    		expect(assigns(:recipes)[0].user_recipes_like).to be_nil
    		expect(assigns(:recipes)[0].user_recipes_rating).to be_nil
    	end
    	it "assigns the requested recipe to @recipe with a user issue" do
    		user_issue = create(:user_issue,user_id: @user.id, issue_id: @issue.id)
    		get :show, id:@category
    		expect(assigns(:recipes)).to match_array(@recipe)
    		expect(assigns(:recipes)[0].user_owned).to eq user_issue.id
    	end
    	it "assigns the requested recipe to @recipe with a user recipe" do
    		user_recipe = create(:user_recipe,user_id: @user.id, recipe_id: @recipe.id,like: 1, rating: 2)
    		get :show, id:@category
    		expect(assigns(:recipes)).to match_array(@recipe)
    		expect(assigns(:recipes)[0].user_recipes_like).to eq 1
    		expect(assigns(:recipes)[0].user_recipes_rating).to eq 2
    	end

    end
  end

end
