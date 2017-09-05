require 'rails_helper'

RSpec.feature "AddMovieToWishlists", type: :feature do
  scenario "User adds a movie to her wishlist" do
    visit movies_new_path
    fill_in 'search', with: 'kill bill'
    click_on "Search"
    expect(page).to have_content("24 - Kill Bill: Vol. 1")
    expect { click_on "24 - Kill Bill: Vol. 1" }.to change {Movie.count}.from(0).to(1)
  end
end
