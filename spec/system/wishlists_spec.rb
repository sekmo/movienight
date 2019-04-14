require "rails_helper"

RSpec.describe "Managing the wishlist", type: :system do
  let(:user) { create(:user) }

  before(:each) do
    login_as user, scope: :user
  end

  scenario "User adds a movie to her wishlist" do
    visit new_wish_path
    fill_in "search", with: "kill bill 1"
    stub_request(:get, /api.themoviedb.org\/3\/search\/movie\?adult=false&api_key=.*&query=kill%20bill/)
      .to_return(status: 200, body: file_fixture("tmdb_search_movie.json").read)

    click_on "Search"
    expect(page).to have_content("Kill Bill: Vol. 1")

    movie_span = page.all("span", text: "Kill Bill: Vol. 1").first
    movie_span_container = movie_span.first(:xpath, ".//../..")

    stub_request(:get, /api.themoviedb.org\/3\/movie\/24\?api_key=.*&append_to_response=credits,videos/)
      .to_return(status: 200, body: file_fixture("tmdb_movie_details.json").read)
    expect {
      movie_span_container.click_on("Add to watchlist")
    }.to change { user.wishes.count }.by(1)

    expect(WebMock).to have_requested(:get, /api.themoviedb.org\/3\/search\/movie\?adult=false&api_key=.*&query=kill%20bill/).once
    expect(WebMock).to have_requested(:get, /api.themoviedb.org\/3\/movie\/24\?api_key=.*&append_to_response=credits,videos/).once
  end

  scenario "User removes a movie from her wishlist", js: true do
    movie = create(:movie)
    create(:wish, movie: movie, user: user)
    visit wishes_path
    expect(page).to have_content movie.title

    movie_li = find("li", text: movie.title)

    expect(user.wishes.count).to eq(1)

    movie_li.click_on("Remove")
    expect(page).not_to have_content movie.title
    expect(user.wishes.count).to eq(0)

    # TODO Why doesn't it work?
    # expect {
    #   movie_li.click_on("Remove movie")
    #   wait_for_ajax
    # }.to change { @user.reload.wishes.count }.from(1).to(0)
  end
end
