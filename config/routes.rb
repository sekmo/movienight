Rails.application.routes.draw do
  get  'wishes', to: 'wishes#index'
  get  'wishes/new'
  post 'wishes', to: 'wishes#create'

  get 'remote_movies', to: 'remote_movies#index'

  devise_for :users

  get  'pages/:page', to: 'pages#show'
  root 'pages#show', page: 'welcome'
end
