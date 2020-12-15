Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do 
    namespace :v1 do 
      namespace :items do 
        scope '/:id/' do 
          resources :merchants, only: [:index], controller: 'item_merchants'
        end
        get 'find', to: 'search#show'
      end
      namespace :merchants do 
        scope '/:id/' do 
          resources :items, only: [:index], controller: 'merchant_items'
        end
        get 'find', to: 'search#show'
      end
      resources :items
      resources :merchants 
    end
  end

end
