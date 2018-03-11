require "rails_helper"

RSpec.feature "Wishlist", type: :feature do
  before(:each) do
    @user ||= create(:user, profile: nil)
    login_as @user, scope: :user
  end

  scenario "User cannot search for a movie if she doesn't have a profile" do
    visit new_wish_path
    expect(current_path).to eql(new_profile_path)
    expect(page).to have_content "Create a profile to add movies to your wishlist!"
  end

  scenario "User can create a profile" do
    visit new_profile_path
    fill_in "First name", with: "Francesco"
    fill_in "Last name", with: "Mari"
    fill_in "Nickname", with: "sekmo"

    click_on "Create Profile"

    expect(current_path).to eql(new_wish_path)
    expect(page).to have_content "Profile was successfully created. Now create your wishlist!"
  end
end
