Rails.application.routes.draw do
  get 'remote_movies', to: 'remote_movies#index'
  resources :wishes, only: [:new, :index, :create, :update, :destroy]
  resources :friendships
  resources :matches, only: [:new]
  get  'matches/', to: 'matches#show', as: 'match'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :users do
    member do
      get :show
    end
  end

  # resources :public_profiles, only: [:index, :show]

  get  'pages/:page', to: 'pages#show', as: 'pages'
  root 'pages#show', page: 'welcome'
end
