class FriendshipsController < ApplicationController
  before_action :set_friendship, only: [:update, :destroy]

  def index
    @friends = current_user.friends
    @friendship_requests = current_user.friendship_requests
  end

  def create
    recipient = User.find(params[:recipient])
    if current_user.ask_friendship(recipient)
      redirect_to friendships_url, notice: "Friend request sent"
    else
      redirect_to_root_with_error("Friend request already sent")
    end
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
