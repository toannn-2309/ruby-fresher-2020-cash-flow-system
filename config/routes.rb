Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "sessions#new"

    resources :users
    resources :requests
    get "/home", to: "static_pages#home"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    namespace :admin do
      root "base#index"

      resources :users
      resources :requests do 
        member do
          patch :review
          patch :confirm
          patch :rejected
        end
      end
      resources :incomes do
        member do
          patch :confirm
          patch :rejected
        end
      end
      get "/login", to: "sessions#new"
      post "/login", to: "sessions#create"
      delete "/logout", to: "sessions#destroy"
    end

    namespace :manager do
      resources :requests do 
        member do
          patch :review
          patch :rejected
        end
      end
    end

    namespace :accountant do
      resources :requests do 
        member do
          patch :confirm
          patch :rejected
        end
      end
    end
  end
end
