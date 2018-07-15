class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update]
  before_action :enforce_current_user_profile, only: [:index]

  def new
    if current_user_has_profile?
      flash[:notice] = "You already have a profile. Create your wishlist!"
      redirect_to new_wish_path
    else
      @profile = current_user.build_profile
    end
  end

  def show
    @friends = @profile.friends
    @friendship_requests = @profile.friendship_requests
  end

  def index
    term = params[:q]
    redirect_to_root_with_error if term.blank?
    @profiles = Profile.search_by_full_name(term) - [current_user_profile]
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
      redirect_to profile_url
    else
      render "edit"
    end
  end

  private

  def profile_params
    params[:profile].permit(:nickname, :first_name, :last_name)
  end

  def set_profile
    @profile = Profile.find(params[:id])
    check_owner(@profile)
  rescue ActiveRecord::RecordNotFound
    redirect_to_root_with_error
  end
end
