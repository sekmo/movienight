class WishesController < ApplicationController
  def new
  end

  def index
    @wishes = Wish.find_by_user(current_user).includes(:movie)
  end

  def create
    tmdb_code = params[:tmdb_code]
    movie_title = params[:title]
    poster_path = params[:poster_path]
    movie = Movie.find_by(tmdb_code: tmdb_code)
    if movie.nil?
      movie = Movie.create(tmdb_code: tmdb_code, title: movie_title, poster_path: poster_path)
    end
    if movie.persisted?
      wish = Wish.find_or_initialize_by(movie: movie, user: current_user)
      if wish.persisted?
        flash[:notice] = "The movie was already present in your wishlist."
      else
        wish.save!
        flash[:notice] = "The movie has been added successfully to your wishlist."
      end
      redirect_to wishes_url
    else
      flash.now[:alert] = "Error adding the movie to your wishlist."
      render "new"
    end
  end
end
