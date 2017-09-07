class PagesController < ApplicationController
  def show
    render "pages/#{params[:page]}"
  end
end
