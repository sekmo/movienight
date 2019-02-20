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
      let(:tom)   { create(:profile) }
      let(:jerry) { create(:profile) }
      let(:spike) { create(:profile) }

      let(:movie_1) { create(:movie) }
      let(:movie_2) { create(:movie) }
      let(:movie_3) { create(:movie) }
      let(:movie_4) { create(:movie) }

      let!(:tom_wish1)   { create(:wish, movie: movie_1, profile: tom) }
      let!(:jerry_wish1) { create(:wish, movie: movie_2, profile: jerry) }
      let!(:spike_wish1) { create(:wish, movie: movie_3, profile: spike) }

      let!(:tom_wish2)   { create(:wish, movie: movie_4, profile: tom) }
      let!(:jerry_wish2) { create(:wish, movie: movie_4, profile: jerry) }
      let!(:spike_wish2) { create(:wish, movie: movie_4, profile: spike) }

      before do
        user = create(:user, profile: tom)
        login_as user, scope: :user
      end

      it "sets the movies in common among the profiles" do
        match = {
          complete_match: [movie_4],
          partial_match: [movie_1, movie_2, movie_3]
        }

        expect(Movie).to receive(:match_all_profiles).with([2, 3, tom.id]).and_call_original
        get match_path(profiles_ids: [2,3])
        expect(assigns(:movies)).to eq(match)
      end
    end
  end

  describe "GET #new" do
    context "as a public user" do
      it "redirects to login" do
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
