Rails.application.routes.draw do
  get 'movies', to: 'movies#index'
  get 'movies/new'
  get 'remote_movies', to: 'remote_movies#index'
  devise_for :users

  root 'movies#new'
end
