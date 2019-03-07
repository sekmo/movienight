class MatchesController < ApplicationController
  def new
    @friends = current_user_profile.friends
  end

  def show
    @movies = Movie.match_all_users(users_ids + [current_user.id])
    @amount_of_matched_users = params[:users_ids].size + 1
  end

  private

  def users_ids
    params[:users_ids].map(&:to_i)
  end
end
