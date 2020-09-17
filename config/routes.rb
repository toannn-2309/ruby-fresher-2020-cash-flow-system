Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    resources :users
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
  end
end
