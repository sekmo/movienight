class MatchesController < ApplicationController
  def new
    @friends = current_user_profile.friends
  end

  def show
    @movies = Movie.match_all_profiles([current_user_profile.id] + profiles_ids)
  end

  private

  def profiles_ids
    params[:profiles_ids].map(&:to_i)
  end
end
