Rails.application.routes.draw do
  get 'remote_movies', to: 'remote_movies#index'
  resources :wishes
  devise_for :users
  resource :profile, only: [:show, :create, :new, :edit, :update]
  resolve('Profile') { [:profile] }

  get  'pages/:page', to: 'pages#show', as: 'pages'
  root 'pages#show', page: 'welcome'
end
