class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  protected

  def redirect_to_root_with_error(message = "Error in the request")
    flash[:error] = message
    redirect_to root_url
  end

  def check_current_user_owner_of(object)
    if object.user != current_user
      redirect_to_root_with_error
    end
  end

  def flash_discard_if_xhr
    flash.discard if request.xhr?
  end
end
