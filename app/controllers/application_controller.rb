class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :check_current_user_has_profile, if: -> { user_signed_in? }

  protected

  def redirect_to_root_with_error(message = "Error in the request")
    flash[:error] = message
    redirect_to root_url
  end

  def check_current_profile_owner_of(object)
    if object.profile != current_user_profile
      redirect_to_root_with_error
    end
  end

  def flash_discard_if_xhr
    flash.discard if request.xhr?
  end

  def check_current_user_has_profile
    if !current_user_has_profile?
      flash[:notice] = "Create your social profile to continue 😺"
      redirect_to new_profile_path
    end
  end

  def current_user_has_profile?
    helpers.current_user_has_profile?
  end

  def current_user_profile
    helpers.current_user_profile
  end
end
