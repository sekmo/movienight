class PublicProfilesController < ApplicationController
  def index
    term = params[:q]
    redirect_to_root_with_error if term.blank?
    @profiles = Profile.search_by_full_name(term) - [current_user_profile]
  end

  def show
    set_profile
    @friends = @profile.user.friends
  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
    check_owner(@profile)
  rescue ActiveRecord::RecordNotFound
    redirect_to_root_with_error
  end
end
