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
  end
end
