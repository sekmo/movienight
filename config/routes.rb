Rails.application.routes.draw do
  get 'movies', to: 'movies#index'
  get 'movies/new'
  post 'movies', to: 'movies#create'
  get 'remote_movies', to: 'remote_movies#index'
  devise_for :users
  get 'pages/:page', to: 'pages#show'
  root 'pages#show', page: 'welcome'
end
