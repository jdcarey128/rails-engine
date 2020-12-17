Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do 
    namespace :v1 do 
      
      
      namespace :items do 
        get 'find', to: 'search#show'
        get 'find_all', to: 'search#index'
        scope '/:id/' do 
          resources :merchants, only: [:index], controller: 'item_merchants'
        end
      end
      resources :items
      
      get '/revenue', to: 'merchants/business#total_revenue'
      
      namespace :merchants do 
        get 'find', to: 'search#show'
        get 'find_all', to: 'search#index'
        get 'most_revenue', to: 'business#most_revenue'
        get 'most_items', to: 'business#most_items'
        scope '/:id/' do 
          resources :items, only: [:index], controller: 'merchant_items'
          get '/revenue', to: 'business#merchant_revenue'
        end
      end
      resources :merchants 
    end
  end

end
