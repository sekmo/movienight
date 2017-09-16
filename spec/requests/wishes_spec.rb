require 'rails_helper'

RSpec.describe "Wishes", type: :request do
  describe "Public access to /wishes" do

    it "denies GET to /wishes" do
      get wishes_path
      expect(response).to redirect_to(new_user_session_url)
    end

    it "denies GET to /wishes/new" do
      get wishes_new_path
      expect(response).to redirect_to(new_user_session_url)
    end

    it "denies POST to /wishes" do
      post wishes_path
      expect(response).to redirect_to(new_user_session_url)
    end
  end
end
