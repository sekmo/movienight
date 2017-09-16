require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe "GET /pages/welcome" do
    it "should return success" do
      get :show, params: { page: "welcome" }
      expect(response).to have_http_status(:success)
    end
  end
end
