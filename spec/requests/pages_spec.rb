require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "Visit /pages/welcome" do
    it "should return success" do
      get "/pages/welcome"
      expect(response).to have_http_status(:success)
    end
  end
end
