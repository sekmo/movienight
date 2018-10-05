class RemoteMoviesController < ApplicationController
  def index
    tmdb_client = TMDB::Client.new(Rails.application.secrets.tmdb_api_key)
    @movies = tmdb_client.search_movies(params[:search])
  end
end
