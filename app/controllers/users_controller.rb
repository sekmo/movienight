# This controller has nothing to do with Devise controllers.
# It's used for the friend search and for "your profile" page.
class UsersController < ApplicationController
  def index
    term = params[:q]
    redirect_to_root_with_error if term.blank?
    @users = User.search_by_full_name(term) - [current_user]
  end

  def show
    @user = User.find(params[:id])
    @wishes = Wish.find_by_user(@user).includes(:movie).order(id: :desc)
    @friends = @user.friends
    @friendship_requests = @user.friendship_requests
  end
end
