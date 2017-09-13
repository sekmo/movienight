require 'rails_helper'

RSpec.describe RemoteMoviesController, type: :controller do
  describe "GET #index" do
    context "when user is not logged in" do
      it "redirects unlogged users to login" do
        get :index
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context "when user is logged in" do
      context "when a keyword has been passwed" do
        it "renders the search results page"
      end

      context "when no keywords have been passwed" do
        it "redirects to root" do
          expect(response).to redirect_to(root_url)
        end
      end
    end
  end
end
