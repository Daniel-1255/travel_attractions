Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  get "search", to: "home#search"
  resources :users
  resources :bookmarks
  resources :attractions
  resources :reviews
end
