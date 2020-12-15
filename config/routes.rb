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

      namespace :merchants do 
        get 'find', to: 'search#show'
        get 'find_all', to: 'search#index'
        scope '/:id/' do 
          resources :items, only: [:index], controller: 'merchant_items'
        end
      end
      resources :merchants 
    end
  end

end
