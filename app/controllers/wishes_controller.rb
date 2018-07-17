class WishesController < ApplicationController
  before_action :set_wish, only: [:destroy]
  after_action :flash_discard_if_xhr, only: :destroy

  def new
  end

  def index
    @wishes = Wish.find_by_profile(current_user_profile).includes(:movie)
  end

  def create
    movie = Movie.create_with(title: params[:title], poster_path: params[:poster_path])
                 .find_or_create_by!(tmdb_code: params[:tmdb_code])
    wish = Wish.find_or_initialize_by(movie: movie, profile: current_user_profile)
    if wish.persisted?
      flash[:notice] = "The movie was already present in your wishlist."
    else
      wish.save!
      flash[:success] = "The movie has been added successfully to your wishlist."
    end
    redirect_to wishes_url
  end

  def destroy
    if @wish.destroy
      flash[:success] = "The movie was successfully removed from your wishlist."
    end
    respond_to do |format|
      format.html { redirect_to wishes_url }
      format.js
    end
  end

  private

  def set_wish
    @wish = Wish.find(params[:id])
    check_current_profile_owner_of @wish
  rescue ActiveRecord::RecordNotFound
      redirect_to_root_with_error
  end
end
