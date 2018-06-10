require 'rails_helper'

RSpec.describe "Friendships", type: :request do
  describe "Access to /friendships" do
    it "denies access to to public users" do
      get friendships_path
      expect(response).to redirect_to(new_user_session_url)
    end

    it "denies access to to users with no profile" do
      user = create(:user, profile: nil)
      login_as user, scope: :user

      get friendships_path
      expect(response).to redirect_to(new_profile_url)
    end
  end

  describe "POST create" do
    #TODO
    it "creates a new friend request"
  end
end
