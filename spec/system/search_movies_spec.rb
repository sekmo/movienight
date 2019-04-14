require "rails_helper"

RSpec.feature "Search for movies", type: :system do
  scenario "User can search for movies" do
    user = create(:user)
    login_as user, scope: :user
    stub_request(:get, /api.themoviedb.org\/3\/search\/movie\?adult=false&api_key=.*&query=kill%20bill/)
      .to_return(status: 200, body: file_fixture("tmdb_search_movie.json").read)

    visit new_wish_path
    fill_in "search", with: "kill bill"
    click_on "Search"

    expect(WebMock).to have_requested(:get, /api.themoviedb.org\/3\/search\/movie\?adult=false&api_key=.*&query=kill%20bill/).once
    expect(page).to have_content("Kill Bill: Vol. 1")
  end
end
