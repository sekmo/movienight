require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe "GET index" do
    context "as a public user" do
      it "denies access" do
        get users_path, params: { q: "query" }
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context "as a logged user" do
      let!(:francesco) { create(:user, first_name: "Francesco", last_name: "Mari", username: "sekmo") }
      let!(:andrea) { create(:user, first_name: "Andrea", last_name: "Rossi", username: "frank") }
      let!(:mario) { create(:user, first_name: "Mario", last_name: "Franceschini", username: "marione") }

      before do
        user = create(:user)
        login_as user, scope: :user
      end

      it "returns the searched users" do
        expect(User).to receive(:search_by_full_name).with("fra").and_call_original
        get users_path, params: { q: "fra" }

        expect(response).to have_http_status(:success)
        expect(assigns(:users)).to eq([francesco, andrea, mario])
        expect(response.body).to include("Francesco Mari", "Andrea Rossi", "Mario Franceschini")
      end
    end
  end

  describe "GET show" do
    context "as a public user" do
      it "denies access" do
        get user_path(id: "WHATEVER")
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context "as a logged user" do
      before do
        @francesco = create(:user)
        login_as @francesco, scope: :user
      end

      it "sets the user, friends, and friendship_requests" do
        get user_path(id: @francesco.id)

        expect(response).to have_http_status(:success)
        expect(assigns(:user)).to eq(@francesco)
        expect(assigns(:friends)).to eq(@francesco.friends)
        expect(assigns(:friendship_requests)).to eq(@francesco.friendship_requests)
      end
    end
  end

end
