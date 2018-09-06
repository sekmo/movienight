require 'rails_helper'

RSpec.describe MatchesController, type: :request do
  describe "#show" do
    context "as a public user" do
      it "denies access" do
        get match_path(profiles_ids: [2,3])
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context "as an authenticated user" do
      let(:movies) { create_list(:movie, 3) }
      let(:user) { create(:user, :with_profile) }

      before do
        login_as user, scope: :user
      end

      it "sets the movies in common among the profiles" do
        expect(Movie).to receive(:match_all_profiles).with([user.profile.id,2,3]).and_return(movies)
        get match_path(profiles_ids: [2,3])
        expect(assigns(:movies)).to eq(movies)
      end
    end
  end

  describe "GET #new" do
    context "as a public user" do
      it "returns http success" do
        get new_match_path
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context "as an authenticated user" do
      before  do
        user = create(:user, :with_profile)
        login_as user, scope: :user
      end

      it "returns http success" do
        get new_match_path
        expect(response).to have_http_status(:success)
      end
    end
  end
end
