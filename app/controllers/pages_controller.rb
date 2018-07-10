class PagesController < ApplicationController
  skip_before_action :authenticate_user!, :enforce_current_user_profile

  def show
    render "pages/#{params[:page]}"
  end
end
