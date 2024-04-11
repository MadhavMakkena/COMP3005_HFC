Rails.application.routes.draw do
  # Set the root url
  get "home/index"
  root to: "home#index"

  # Resources
  resources :users

  # Login Routes
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "login", to: "sessions#new"
end
