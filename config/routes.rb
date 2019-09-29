Rails.application.routes.draw do
  resources :movies, only: [:index, :show]
  resources :wishes, only: [:new, :create, :update, :destroy]
  resources :friendships
  resources :matches, only: [:new]
  get  'matches/', to: 'matches#show', as: 'match'
  devise_for :users, controllers: { registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :users

  get  'pages/:page', to: 'pages#show', as: 'pages'

  authenticated :user do
    root 'users#me', as: :authenticated_root
  end
  root 'pages#show', page: 'welcome'
end
