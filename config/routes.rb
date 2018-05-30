Rails.application.routes.draw do
  get 'remote_movies', to: 'remote_movies#index'
  resources :wishes, only: [:new, :index, :create, :update, :destroy]
  resources :friendships
  devise_for :users
  resources :profiles, only: [:index, :show, :create, :new, :edit, :update]
  # resolve('Profile') { [:profile] }

  get  'pages/:page', to: 'pages#show', as: 'pages'
  root 'pages#show', page: 'welcome'
end
