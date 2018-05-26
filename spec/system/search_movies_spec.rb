require "rails_helper"

RSpec.feature "Search for movies", type: :feature do
  scenario "User with profile can search for movies" do
    user = create(:user, :with_profile)
    login_as user, scope: :user
    visit new_wish_path
    fill_in "search", with: "kill bill"

    click_on "Search"

    expect(page).to have_content("Kill Bill: Vol. 1")
  end

  scenario "User without profile cannot search for movies" do
    user = create(:user)
    login_as user, scope: :user

    visit new_wish_path

    expect(current_path).to eql(new_profile_path)
    expect(page).to have_content "Create a profile to add movies to your wishlist!"
  end
end
