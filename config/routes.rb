require "sidekiq/web"

Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    devise_for :users, controllers: {registrations: :registrations}

    devise_scope :user do
      root to: "devise/sessions#new"
    end

    resources :users
    resources :requests
    get "/home", to: "static_pages#home"

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
      devise_scope :user do
        get "/login", to: "sessions#new"
        post "/login", to: "sessions#create"
        delete "/logout", to: "sessions#destroy"
      end
    end

    namespace :manager do
      resources :requests do 
        member do
          patch :review
          patch :rejected
        end
      end
      resources :incomes
      get "/my_income", to: "my_incomes#index"
    end

    namespace :accountant do
      resources :requests do 
        member do
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
    end
    mount Sidekiq::Web, at: "/sidekiq"
  end
end
