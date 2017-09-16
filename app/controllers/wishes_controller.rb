class WishesController < ApplicationController
  def new
  end

  def index
    @wishes = Wish.find_by_user(current_user).includes(:movie)
  end

  def create
    tmdb_code = params[:tmdb_code]
    movie_title = params[:title]
    user_id = current_user.id
    movie = Movie.find_or_create_by(tmdb_code: tmdb_code, title: movie_title)
    if movie.persisted?
      Wish.create(movie: movie, user: current_user)
      flash[:notice] = "The note has been created successfully."
      redirect_to wishes_url
    else
      flash.now[:alert] = "Error adding the movie to your wishlist."
      render 'new'
    end
  end
end
