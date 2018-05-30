class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update]
  before_action :check_profile, only: [:index]

  def new
    if current_user.profile.present?
      flash[:notice] = "You already have a profile. Create your wishlist!"
      redirect_to new_wish_path
    else
      @profile = current_user.build_profile
    end
  end

  def show
  end

  def index
    term = params[:q]
    redirect_to_root_with_error if term.blank?
    @profiles = Profile.search_by_full_name(term)
  end

  def create
    @profile = current_user.build_profile(profile_params)

    if @profile.save
      flash[:success] = "Profile was successfully created. Now create your wishlist!"
      redirect_to new_wish_path
    else
      flash[:error] = "There are some errors on the profile"
      render "profiles/new"
    end
  end

  def edit
  end

  def update
    if @profile.update_attributes(profile_params)
      flash[:notice] = "The update has been updated."
      render "show"
    else
      render "edit"
    end
  end

  private

  def profile_params
    params[:profile].permit(:nickname, :first_name, :last_name)
  end

  def set_profile
    @profile = Profile.find_by_user_id!(current_user)

    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Profile not found. Create a profile to add movies to your wishlist!"
      redirect_to new_profile_path
  end
end
