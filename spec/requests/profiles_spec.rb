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

    it "returns the profiles" do
      user = create(:user, :with_profile)
      login_as user, scope: :user

      # expect(Profile).to receive(:search_by_full_name).with("fra").returns([francesco, andrea, mario])
      get profiles_path, params: { q: "fra" }

      expect(response).to have_http_status "200"
      expect(response.body).to include("Francesco Mari", "Andrea Rossi", "Mario Franceschini")
    end
  end
end
