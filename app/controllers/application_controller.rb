class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :enforce_current_user_profile, if: -> { user_signed_in? }

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

  def enforce_current_user_profile
    if !current_user.profile.try(:persisted?)
      flash[:notice] = "Create your social profile to continue 😺"
      redirect_to new_profile_path
    end
  end
end
