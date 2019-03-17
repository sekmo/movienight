class FriendshipsController < ApplicationController
  before_action :set_friendship, only: [:update, :destroy]

  def create
    receiver = User.find(params[:receiver])
    if current_user.ask_friendship(receiver)
      redirect_to profile_path(current_user_profile), notice: "Friend request sent"
    else
      redirect_to_root_with_error("Friend request already sent")
    end
  end

  def update
    if @friendship.receiver == current_user && @friendship.confirm!
      flash[:notice] = "You have a new friend! ❤️"
      redirect_to profile_path(current_user_profile)
    else
      redirect_to_root_with_error
    end
  end

  def destroy
    if current_user.in? [@friendship.sender, @friendship.receiver]
      @friendship.destroy
      flash[:notice] = "You've lost a friend. 💔"
      redirect_to profile_path(current_user_profile)
    else
      redirect_to_root_with_error
    end
  end

  private

  def set_friendship
    @friendship = Friendship.find(params[:id])
  end
end
