Rails.application.routes.draw do
  # Set the root url
  get "home/index"
  root to: "home#index"

  # Resources
  resources :users
  resources :health_metrics
  resources :training_sessions
  resources :room_bookings

  # Login Routes
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "login", to: "sessions#new"
end
