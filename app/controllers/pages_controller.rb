class PagesController < ApplicationController
  skip_before_action :authenticate_user!, :check_current_user_has_profile

  def show
    render "pages/#{params[:page]}"
  end
end
