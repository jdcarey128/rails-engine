Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do 
    namespace :v1 do 
      namespace :items do 
        get 'find', to: 'search#show'
        scope '/:id/' do 
          resources :merchants, only: [:index], controller: 'item_merchants'
        end
      end
      namespace :merchants do 
        scope '/:id/' do 
          resources :items, only: [:index], controller: 'merchant_items'
        end
      end
      resources :items
      resources :merchants 
    end
  end

end
