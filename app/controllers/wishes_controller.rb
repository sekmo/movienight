class WishesController < ApplicationController
  before_action :set_wish, only: [:destroy]

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

  def destroy
    @wish.destroy
    flash[:notice] = "The movie was successfully removed from your wishlist."
    redirect_to wishes_url
  end

  private

  def set_wish
    @wish = Wish.find(params[:id])
    check_owner @wish
    rescue ActiveRecord::RecordNotFound
      redirect_to_root_with_error
  end
end
