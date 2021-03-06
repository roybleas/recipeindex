Rails.application.routes.draw do

  
  get 'admin_pages/home'

	resources :users
  get   'signup'  => 'users#new'
  get 	'login'		=> 'sessions#new'
  post 	'login'		=> 'sessions#create'
  delete 'logout'	=> 'sessions#destroy'
  
  root 'issues#index'
  resources :publications, only: [:show, :edit, :update ] do
  	member do
  		get 'issues'
  		get 'userissues'
  		patch 'userissuesupdate' 
  	end
  end
  
  namespace :admin do
  	resources :publications, only: [:index]
	end
	
	resources :issues, only: [:index, :show] do
  	member do
    	get 'years'
    	get 'descriptions'
  	end
	end
	
	resources :categories, only:[:index, :show] 
	
	get 'categories/byletter/:letter', to: 'categories#byletter',  as: 'byletter_categories'
	
	resources :recipes, only:[:show] do
		resources :userrecipes, only: [:new, :create]
	end
	
	resources :userrecipes, only:[:edit, :update]
	
  get 'bymonth/:id', to: 'recipes#bymonth', constraints: { id: /([1-9]|([1-9][0-2]))/ }, as: 'bymonth'
	get 'selectmonth/:id', to: 'recipes#selectmonth', constraints: { id: /([1-9]|([1-9][0-2]))/ }, as: 'selectmonth'

    
  
 
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  #root 'welcome#index'
  

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
