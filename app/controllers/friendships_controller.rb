class FriendshipsController < ApplicationController
  before_action :set_friendship, only: [:update, :destroy]

  def create
    receiver = Profile.find(params[:receiver])
    if current_user_profile.ask_friendship(receiver)
      redirect_to profile_path(current_user_profile), notice: "Friend request sent"
    else
      redirect_to_root_with_error("Friend request already sent")
    end
  end

  def update
    if @friendship.receiver == current_user_profile && @friendship.confirm!
      flash[:notice] = "You have a new friend! ❤️"
      redirect_to profile_path(current_user_profile)
    else
      redirect_to_root_with_error
    end
  end

  def destroy
    if current_user_profile.in? [@friendship.sender, @friendship.receiver]
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

    rescue ActiveRecord::RecordNotFound
      redirect_to_root_with_error
  end
end
