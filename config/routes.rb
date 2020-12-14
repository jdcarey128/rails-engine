Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do 
    namespace :v1 do 
      resources :items
      resources :merchants 
      scope '/merchants/:id/' do 
        resources :items, only: [:index], controller: 'merchant_items'
      end
      scope '/items/:id/' do 
        resources :merchants, only: [:index], controller: 'item_merchants'
      end
    end
  end

end
