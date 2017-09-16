require 'rails_helper'

RSpec.describe "RemoteMovies", type: :request do
  describe "Public access to /remote_movies" do
    it "denies access to /remote_movies" do
      get remote_movies_path
      expect(response).to redirect_to(new_user_session_url)
    end
  end
end
