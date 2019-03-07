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
      let(:tom)   { create(:user, :with_profile) }
      let(:jerry) { create(:user) }
      let(:spike) { create(:user) }

      let(:movie_1) { create(:movie) }
      let(:movie_2) { create(:movie) }
      let(:movie_3) { create(:movie) }
      let(:movie_4) { create(:movie) }

      let!(:tom_wish1)   { create(:wish, movie: movie_1, user: tom) }
      let!(:jerry_wish1) { create(:wish, movie: movie_2, user: jerry) }
      let!(:spike_wish1) { create(:wish, movie: movie_3, user: spike) }

      let!(:tom_wish2)   { create(:wish, movie: movie_4, user: tom) }
      let!(:jerry_wish2) { create(:wish, movie: movie_4, user: jerry) }
      let!(:spike_wish2) { create(:wish, movie: movie_4, user: spike) }

      before do
        login_as tom, scope: :user
      end

      it "sets the movies in common among the users" do
        match = {
          complete_match: [movie_4],
          partial_match: [movie_1, movie_2, movie_3]
        }

        expect(Movie).to receive(:match_all_users).with([2, 3, tom.id]).and_call_original
        get match_path(users_ids: [2,3])
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
