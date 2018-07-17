require 'rails_helper'

RSpec.describe ProfilesController, type: :request do
  describe "Access to /profiles" do
    it "denies access to to public users" do
      get new_profile_path
      expect(response).to redirect_to(new_user_session_url)
    end
  end

  describe "GET index" do
    let!(:francesco) { create(:profile, first_name: "Francesco", last_name: "Mari", nickname: "sekmo") }
    let!(:andrea) { create(:profile, first_name: "Andrea", last_name: "Rossi", nickname: "frank") }
    let!(:mario) { create(:profile, first_name: "Mario", last_name: "Franceschini", nickname: "marione") }

    it "returns the searched profiles" do
      user = create(:user, :with_profile)
      login_as user, scope: :user

      expect(Profile).to receive(:search_by_full_name).with("fra").and_call_original
      get profiles_path, params: { q: "fra" }

      expect(response).to have_http_status(:success)
      expect(assigns(:profiles)).to eq([francesco, andrea, mario])
      expect(response.body).to include("Francesco Mari", "Andrea Rossi", "Mario Franceschini")
    end

    it "denies access to users with no profile" do
    end
  end

  describe "GET show" do
    it "denies access to a profile that doesn't belong to the current logged user" do
      francesco = create(:user, :with_profile)
      another_profile = create(:profile)
      login_as francesco, scope: :user

      get profiles_path(id: another_profile.id)

      expect(response).to redirect_to(root_url)
    end

    it "sets the profile, friends, and friendship_requests" do
      francesco = create(:user, :with_profile)
      login_as francesco, scope: :user

      get profile_path(id: francesco.profile.id)

      expect(response).to have_http_status(:success)
      expect(assigns(:profile)).to eq(francesco.profile)
      expect(assigns(:friends)).to eq(francesco.profile.friends)
    end
  end
end
