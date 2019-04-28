require "rails_helper"

RSpec.feature "Registration", type: :system do
  scenario "User can register" do
    visit new_user_registration_path

    fill_in "First name", with: "Francesco"
    fill_in "Last name", with: "Mari"
    fill_in "Username", with: "sekmo"
    fill_in "Email", with: "francescojjmari@gmail.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"

    click_on "Sign up"

    expect(page).to have_content "Welcome! You have signed up successfully."
  end

  # TODO add test for image attachment
  scenario "User can update her data" do
    @user ||= create(
      :user,
      first_name: "Francesco",
      last_name: "Mari",
      username: "sekmo",
      email: "francescojjmari@gmail.com"
    )
    login_as @user, scope: :user
    visit edit_user_registration_path(@user)

    fill_in "First name", with: "François"
    fill_in "Last name", with: "Mers"
    fill_in "Username", with: "sekmó"
    fill_in "Email", with: "francoisjjmers@gmail.com"
    fill_in "Password", with: "lenouveaumotdepasse"
    fill_in "Password confirmation", with: "lenouveaumotdepasse"
    fill_in "Current password", with: @user.password

    expect do
      click_on("Update profile")
      @user.reload
    end .to change  { @user.first_name }.from("Francesco").to("François")
     .and change { @user.last_name }.from("Mari").to("Mers")
     .and change { @user.username }.from("sekmo").to("sekmó")
     .and change { @user.email }.from("francescojjmari@gmail.com").to("francoisjjmers@gmail.com")

    # Check if the password has been changed correctly:
    click_on("Logout")
    visit new_user_session_path
    fill_in "Email", with: "francoisjjmers@gmail.com"
    fill_in "Password", with: "lenouveaumotdepasse"
    click_on "Log in"
    expect(page).to have_content "Signed in successfully."
  end
end
