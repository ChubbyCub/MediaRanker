Rails.application.routes.draw do
  root to: "homepages#index"
  resources :works do
    resources :votes, only: [:create]
  end

  get "/users", to: "users#index", as: "users"
  get "/login", to: "users#login_form", as: "login"
  post "/login", to: "users#login"
  post "/logout", to: "users#logout", as: "logout"
  get "/users/:id", to: "users#show", as: "user"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
