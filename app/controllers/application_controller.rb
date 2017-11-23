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
end
