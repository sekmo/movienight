require "rails_helper"

RSpec.feature "Add movie to wishlist", type: :feature do
  before do
    user = create(:user)
    login_as(user, scope: :user)
  end

  scenario "User adds a movie to her wishlist" do
    visit wishes_new_path
    fill_in "search", with: "kill bill"
    click_on "Search"
    expect(page).to have_content("24 - Kill Bill: Vol. 1")
    expect { click_on "24 - Kill Bill: Vol. 1" }.to change { Wish.count }.from(0).to(1)
  end
end
