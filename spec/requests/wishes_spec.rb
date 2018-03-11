require 'rails_helper'

RSpec.describe "Wishes", type: :request do
  describe "Public access to /wishes" do
    it "denies GET to /wishes" do
      get wishes_path
      expect(response).to redirect_to(new_user_session_url)
    end

    it "denies GET to /wishes/new" do
      get new_wish_path
      expect(response).to redirect_to(new_user_session_url)
    end

    it "denies POST to /wishes" do
      post wishes_path
      expect(response).to redirect_to(new_user_session_url)
    end
  end

  describe "Access to /wishes from users with no profile" do
    before(:each) do
      @user ||= create(:user)
      login_as @user, scope: :user
    end

    it "denies GET to /wishes" do
      get wishes_path
      expect(response).to redirect_to(new_profile_url)
    end

    it "denies GET to /wishes/new" do
      get new_wish_path
      expect(response).to redirect_to(new_profile_url)
    end

    it "denies POST to /wishes" do
      post wishes_path
      expect(response).to redirect_to(new_profile_url)
    end
  end
end
