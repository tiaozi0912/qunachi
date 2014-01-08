Me::Application.routes.draw do
  resources :users do 
    collection do 
      get 'profile'
      get 'categories_cities'
    end
  end

  get 'user', to: 'users#show'
  get 'get_renren_feeds', to: 'users#get_renren_feeds'

  resources :user_sessions do 
    collection do 
      get 'get_weibo_access_token'
      get 'get_renren_access_token'
    end
  end

  resources :restaurants

  resources :categories
  resources :cities

  namespace :admin do
    resources :restaurants do 
      collection do 
        get 'load_sheet_to_database'
        get 'list'
      end
    end
  end

  match '/signin' => 'user_sessions#new'
  match '/signout' => 'user_sessions#destroy'
  root :to => 'users#home'
end
