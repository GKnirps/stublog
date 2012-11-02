Stublog::Application.routes.draw do
  resources :quote_of_the_days, except: :show do
	member do
  		#Add a rout for confirm destroy (I don't want to use JS)
		get 'confirm_destroy'
	end
  end
  
  resources :categories do
	member do
  		#Add a rout for confirm destroy (I don't want to use JS)
		get 'confirm_destroy'
	end
  end
  #tags are implicitely created and edited
  resources :tags, only: [:show, :index] do
  	collection do
		#search for tags
		get 'search'
		post 'search', action: :find
	end
  end

  resources :hosted_files do
	member do
  		#Add a rout for confirm destroy (I don't want to use JS)
		get 'confirm_destroy'
		#download invokes sending of the file
		get 'download'
	end
  end
  resources :blogposts do
  	#Comments are shown and edited in the Blogpost view
  	resources :comments, only: [:create, :update, :destroy, :edit] do
		member do
	  		#Add a rout for confirm destroy (I don't want to use JS)
			get 'confirm_destroy'
			#add route for answering this comment
			get 'answer'
		end
	end
  	#Add a rout for confirm destroy (I don't want to use JS)
	member do
		get 'confirm_destroy'
	end
  end
  resources :users do
  	member do
  		#Add a rout for confirm destroy (I don't want to use JS)
		get 'confirm_destroy'
	end
  end


  resources :sessions, only: [:new, :create, :destroy]

  root to: 'static_pages#home'

  match '/home', to: "static_pages#home"

#  match '/contact', to: "static_pages#contact"

  match '/signup', to: "users#new"

  #the atom feed
  match '/feed', to: 'blogposts#feed'

  match '/signin', to: "sessions#new"

  match '/signout', to: "sessions#destroy"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
