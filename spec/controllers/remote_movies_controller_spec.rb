require 'rails_helper'

RSpec.describe RemoteMoviesController, type: :controller do
  describe "GET index" do
    it "redirects unlogged users to login" do
      get :index
      expect(response).to redirect_to(new_user_session_url)
    end
  end
end
