require 'rails_helper'

RSpec.describe "Profiles", type: :request do
  describe "Access to /profile" do
    it "denies access to to public users" do
      get "/profile/new"
      expect(response).to redirect_to(new_user_session_url)
    end
  end
end
