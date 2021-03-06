Happening::Application.routes.draw do

  devise_scope :user do
    get "/signin" => "devise/sessions#new"
    delete "/signout" => "devise/sessions#destroy"
    get "/signup" => "devise/registrations#new"
    get "/settings" => "devise/registrations#edit"
  end

  devise_for :users

  resources :users, only: [:index, :show] do
    resources :statuses, only: [:create, :destroy], shallow: true
    member do
      get :following, :followers
    end
  end
  
  resources :relationships, only: [:create, :destroy]

  resources :statuses, only: [:show] do
    resources :likes, only: [:create, :destroy], shallow: true
    resources :comments, only: [:create], shallow: true
  end

  resources :comments, only: [:show, :destroy] do
    resources :likes, only: [:create, :destroy], shallow: true
  end

  resources :landmarks, only: [:index, :show] do
    resources :likes, only: [:create, :destroy], shallow: true
    resources :comments, only: [:create], shallow: true
  end

  resources :restaurants, only: [:index, :show] do
    resources :likes, only: [:create, :destroy], shallow: true
    resources :comments, only: [:create], shallow: true
  end

  resources :photos, only: [:index, :show] do
    resources :likes, only: [:create, :destroy], shallow: true
    resources :comments, only: [:create], shallow: true
  end

  resources :events, only: [:index, :show] do
    resources :likes, only: [:create, :destroy], shallow: true
    resources :comments, only: [:create], shallow: true
  end

  resources :deals, only: [:index, :show] do
    resources :likes, only: [:create, :destroy], shallow: true
    resources :comments, only: [:create], shallow: true
  end

  root to: 'static_pages#home'
  match '/help', to: 'static_pages#help'
  match '/about', to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'

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
