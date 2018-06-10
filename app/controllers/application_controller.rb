class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, :check_profile

  protected

  def redirect_to_root_with_error(message = "Error in the request")
    flash[:error] = message
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
    if user_signed_in? && current_user.profile.nil?
      flash[:notice] = "Create a profile to add movies to your wishlist!"
      redirect_to new_profile_path
    end
  end
end
