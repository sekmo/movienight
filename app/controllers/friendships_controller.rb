class FriendshipsController < ApplicationController
  before_action :check_profile
  before_action :set_friendship, only: [:update, :destroy]

  def index
    @friends = current_user.friends
    @friendship_requests = current_user.friendship_requests
  end

  def create
    current_user.ask_friendship(params[:recipient])
  end

  def update
    if @friendship.recipient == current_user && @friendship.confirm!
      flash[:notice] = "You have a new friend! ❤️"
      redirect_to friendships_url
    else
      redirect_to_root_with_error
    end
  end

  def destroy
    if current_user.in? [@friendship.sender, @friendship.recipient]
      @friendship.destroy
      flash[:notice] = "You've lost a friend. 💔"
      redirect_to friendships_url
    else
      redirect_to_root_with_error
    end
  end

  private

  def set_friendship
    @friendship = Friendship.find(params[:id])

    rescue ActiveRecord::RecordNotFound
      redirect_to_root_with_error
  end
end
