Rails.application.routes.draw do
  if Rails.env.development?
    # Sidekiq monitoring app
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  get 'user/dashboard', as: :dashboard
  
  match 'band/:band_id/songs/find_media', to: 'song#batch_find_media', as: :band_song_batch_find_media, via: [:get]
  
  resources :band do
    resources :setlists, controller: 'setlist'
    resources :concerts, controller: 'concert'
    resources :songs, controller: 'song'
  end
  
  # Handy path for master setlist
  match 'band/:band_id/setlist', to: 'setlist#show', as: :band_master_setlist, via: [:get], setlist_id: 1
  
  match 'band/:band_id/setlist/add_song', to: 'setlist#add_song', as: :add_song_to_setlist, via: [:post]
  match 'band/:band_id/setlist/remove_song/:song_id', to: 'setlist#remove_song', as: :remove_song_from_setlist, via: [:post]
  match 'band/:band_id/setlist/add_batch', to: 'setlist#add_batch', as: :add_batch_to_setlist, via: [:post]
  match 'band/:band_id/setlist/export', to: 'setlist#export', as: :setlist_export_txt, via: [:get]
  
  match 'band/:band_id/songs/:id/find_media', to: 'song#find_media', as: :band_song_find_media, via: [:get]
  
  match 'band/:band_id/concerts/:id/setlist_builder', to: 'setlist#setlist_builder', as: :setlist_builder, via: [:get]
  match 'band/:band_id/concerts/:id/setlist', to: 'setlist#update_concert_setlist', as: :update_concert_setlist, via: [:post]
  match 'band/:band_id/concerts/:id/setlist/export', to: 'concert#export_lyrics', as: :setlist_export_lyrics, via: [:get]
  
  match 'invite/:invite_code', to: 'band#invite', as: :invite, via: [:get]
  match 'band/:band_id/invite/request_access', to: 'band#request_access', as: :band_request_access, via: [:post]
  match 'band/:id/invite/grant_access', to: 'band#grant_access', as: :band_grant_access, via: [:post]

  get 'welcome/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  match 'auth/:provider/callback', to: 'session#create', as: 'signin', via: [:get, :post]
  match 'auth/failure', to: 'session#auth_failure', via: [:get, :post]
  match 'signout', to: 'session#destroy', as: 'signout', via: [:get, :post]

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
