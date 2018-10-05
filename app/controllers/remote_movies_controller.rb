class RemoteMoviesController < ApplicationController
  def index
    tmdb_client = Client.new(Rails.application.secrets.tmdb_api_key)
    # @movies = TMDB::Search(params[:search])
    @movies = tmdb_client.search_movies(params[:search])
  end
end
