require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  describe "GET #index" do
    context "when user is not logged in" do
      it "redirects to login" do

        get :index

        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end




  describe "POST #create" do
    context "when user is logged in" do
      before do
        sign_in @user
      end

      it "creates a new movie" do
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        post :create
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end
end
