class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  protected

  def redirect_to_root_with_error
    flash[:error] = "Error in your request"
    redirect_to root_url
  end

  def check_owner(object)
    if object.user != current_user
      redirect_to_root_with_error
    end
  end

  def flash_discard_if_xhr
    flash.discard if request.xhr?
  end

  def check_profile
    if current_user.profile.blank?
      flash[:notice] = "Create a profile to add movies to your wishlist!"
      redirect_to new_profile_path
    end
  end
end
