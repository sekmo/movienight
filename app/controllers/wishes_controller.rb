class WishesController < ApplicationController
  def new
  end

  def index
    @wishes = Wish.find_by_user(current_user).includes(:movie)
  end

  def create
    movie = Movie.create_with(title: params[:title], poster_path: params[:poster_path])
                 .find_or_create_by!(tmdb_code: params[:tmdb_code])
    wish = Wish.find_or_initialize_by(movie: movie, user: current_user)
    if wish.persisted?
      flash[:notice] = "The movie was already present in your wishlist."
    else
      wish.save!
      flash[:notice] = "The movie has been added successfully to your wishlist."
    end
    redirect_to wishes_url
  end
end
