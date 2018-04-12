require 'rails_helper'

RSpec.describe "RemoteMovies", type: :request do
  describe "Access to /remote_movies" do
    it "denies access to to public users" do
      get remote_movies_path
      expect(response).to redirect_to(new_user_session_url)
    end

    it "denies access to to users with no profile" do
      user = create(:user, profile: nil)
      login_as user, scope: :user

      get remote_movies_path
      expect(response).to redirect_to(new_profile_url)
    end
  end
end
