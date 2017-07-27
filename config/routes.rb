Rails.application.routes.draw do
  
  resources :schedules do
    collection do
      get '/:month/:year' => :monthly_schedule
    end
  end
  resources :mission_types do 
    member do 
      get 'add_rules'
    end
    resources :rules 
    resources :mission_type_rules
  end

  resources :rules do
    member do 
      get 'add_mission_types'
    end
  end
  resources :holidays
  resources :calendar_hitch_dates

  # resources :pilots_hitches

  resources :calendars do
    member do
      get 'add_holidays'
      patch 'holidays_update'
    end
    resources :calendars_hitches
    resources :hitches
    resources :calendars_holidays
  end

  
  resources :hitches do
    member do
      get 'add_pilots'
      patch 'pilots_update'
    end
    resources :pilots_hitches do 
      member do
        get 'switch'
      end
    end
  end

  resources :pilots_hitches
  
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'users#index'

  resources :users do
    collection do
      get 'available_pilots'
    end
    member do
      get 'add_hitches'
      patch 'hitches_update'
    end
  end
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
