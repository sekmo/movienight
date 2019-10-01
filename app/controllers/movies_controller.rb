class MoviesController < ApplicationController
  def index
    if params[:search]
      @movies = Movie.search_by_title(params[:search])
    else
      []
    end
  end

  def show
    @movie = Movie.find(params[:id])

    respond_to do |format|
      format.html #{ redirect_to movie_url(@wish.movie) }
      format.js
    end
  end
end
