class MatchesController < ApplicationController
  def new
    @friends = current_user_profile.friends
  end

  def show
    @movies = Movie.match_all_profiles(profiles_ids + [current_user_profile.id])
    @amount_of_matched_users = params[:profiles_ids].size + 1
  end

  private

  def profiles_ids
    params[:profiles_ids].map(&:to_i)
  end
end
