class WishesController < ApplicationController
  before_action :set_wish, only: [:destroy]
  after_action :flash_discard_if_xhr, only: :destroy

  def new
  end

  def create
    wish = Wish.find_or_initialize_by(movie_id: params[:movie_id], user: current_user)

    if wish.persisted?
      flash[:notice] = "The movie was already present in your watchlist."
    else
      wish.save!
      flash[:success] = "The movie has been added to your watchlist."
    end
    redirect_to user_url(current_user)
  end

  def destroy
    if @wish.destroy
      flash[:success] = "The movie was removed from your watchlist."
    end
    respond_to do |format|
      format.html { redirect_to user_url(current_user) }
      format.js
    end
  end

  private

  def set_wish
    @wish = Wish.find(params[:id])
    check_current_user_owner_of @wish
  end
end
