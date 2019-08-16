Rails.application.routes.draw do
  resources :movies, only: [:index]
  resources :wishes, only: [:new, :create, :update, :destroy]
  resources :friendships
  resources :matches, only: [:new]
  get  'matches/', to: 'matches#show', as: 'match'
  devise_for :users, controllers: { registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :users do
    member do
      get :show
    end
  end

  # resources :public_profiles, only: [:index, :show]

  get  'pages/:page', to: 'pages#show', as: 'pages'
  root 'pages#show', page: 'welcome'
end
