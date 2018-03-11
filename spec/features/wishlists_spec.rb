require "rails_helper"

RSpec.feature "Managing the wishlist", type: :feature do
  before(:each) do
    @user ||= create(:user, :with_profile)
    login_as @user, scope: :user
  end

  scenario "User adds a movie to her wishlist" do
    visit new_wish_path
    fill_in "search", with: "kill bill"

    click_on "Search"

    expect(page).to have_content("Kill Bill: Vol. 1")
    movie_span = find("span", text: "Kill Bill: Vol. 1")
    movie_span_container = movie_span.first(:xpath, ".//..")
    expect {
      movie_span_container.click_on("Add to wishlist")
    }.to change { @user.wishes.count }.by(1)
  end

  scenario "User removes a movie from her wishlist", js: true do
    create(:wish, user: @user)
    movie = create(:movie)
    create(:wish, movie: movie, user: @user)
    visit wishes_path

    movie_span = find("span", text: movie.title)
    movie_span_container = movie_span.first(:xpath, ".//..")
    expect {
      accept_alert do
         movie_span_container.click_on("Remove movie")
       end
      wait_for_ajax
    }.to change { @user.wishes.count }.by(-1)
    expect(page).not_to have_content "Kill Bill: Vol. 1"
  end
end
