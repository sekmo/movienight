require 'rails_helper'

RSpec.describe "Wishes", type: :request do
  describe "GET /wishes/new" do
    context "as a public user" do
      it "denies access" do
        get new_wish_path
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context "as a logged user" do
      before do
        user = create(:user)
        login_as user, scope: :user
      end

      it "renders the 'wishes/new' template" do
        get new_wish_path
        expect(response).to render_template("new")
      end
    end
  end

  describe "GET /wishes/index" do
    context "as a public user" do
      it "denies access" do
        get wishes_path
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context "as a logged user" do
      before do
        user = create(:user)
        login_as user, scope: :user
        @wish = create(:wish, user: user)
        @wish2 = create(:wish, user: user)
        @wish3 = create(:wish, user: user)
      end

      it "shows the user's wishes" do
        get wishes_path
        expect(response).to have_http_status(:success)
        expect(assigns(:wishes)).to eq([@wish, @wish2, @wish3])
      end
    end
  end

  describe "POST /wishes" do
    context "as a public user" do
      it "denies posting" do
        post wishes_path, params: { tmdb_code: 22 }
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context "as a logged user, with a cached movie" do
      before do
        @user = create(:user)
        login_as @user, scope: :user
        @movie = create(:movie, tmdb_code: 24)
      end

      it "creates a new wish without calling the TMDB api" do
        expect do
          post wishes_path, params: { tmdb_code: @movie.tmdb_code }
        end .to change {@user.wishes.count}.by(1)
        expect(WebMock).not_to have_requested(:get, /api.themoviedb.org\/3\/movie\/24/)
      end
    end

    context "as a logged user, with an uncached movie" do
      before do
        @user = create(:user)
        login_as @user, scope: :user
      end

      it "creates a new wish" do
        stub_request(:get, /api.themoviedb.org\/3\/movie\/24/)
          .to_return(status: 200, body: file_fixture("tmdb_movie_details.json").read)

        expect do
          post wishes_path, params: { tmdb_code: 24 }
        end .to change {@user.wishes.count}.by(1)
        expect(WebMock).to have_requested(:get, /api.themoviedb.org\/3\/movie\/24/).once
      end
    end
  end

  describe "DELETE /wishes/:id" do
    context "as a public user" do
      it "denies access" do
        delete wish_path(42)
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context "as a logged user" do
      before do
        @user = create(:user)
        login_as @user, scope: :user
        @wish = create(:wish, user: @user)
      end

      it "destroys a user's wish 😢" do
        expect do
          delete wish_path(@wish.id)
        end .to change {@user.wishes.count}.by(-1)
      end

      it "denies destroying another user's wish" do
        @another_user = create(:user)
        @another_user_wish = create(:wish, user: @another_user)
        expect do
          delete wish_path(@another_user_wish.id)
        end .not_to change {@another_user.wishes.count}
      end
    end
  end
end
