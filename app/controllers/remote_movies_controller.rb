class RemoteMoviesController < ApplicationController
  def index
    @movies = TMDB::Client.search_movies(params[:search])
  end
end
