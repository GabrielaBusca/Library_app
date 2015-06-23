Rails.application.routes.draw do
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  resources :contact, :only => [:index]
  
  resources :publishers, :only => [:index, :show]
  resources :domains, :only => [:index, :show]
  resources :authors, :only => [:index, :show]
  
  get '/books/news' => 'books#news'

  resources :books do
    resources :votes, :only => [:create, :index]
    resources :borrows, :only => [:new, :create]
  end

  resources :users, :only => [:show, :index] 
  
  resources :admin, :only => [:index]
  resources :borrows, :only => [:index, :update]

  resources :libraries, :only => [:index, :show] do
    resources :books, :only => [] do
      resources :reservations, :only => [:create]
    end
  end

  resources :reservations, :only => [:destroy] do
    get '/borrow/new' => 'reservations#new_borrow'
    post '/borrow' => 'reservations#create_borrow'
  end

  post '/borrows/:id/extension' => 'borrows#extension'
  post '/borrows/:id/extensions' => 'extensions#create'

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
