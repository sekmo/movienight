require 'rails_helper'

RSpec.describe "Pages", type: :feature do
  scenario "should invite public users to register" do
    visit "/pages/welcome"
    expect(page).to have_content "Register and add your movies"
  end

  scenario "should invite registered user to create a profile" do
    user = create(:user)
    login_as user, scope: :user
    visit "/pages/welcome"
    expect(page).to have_content "Create a profile to continue"
  end
end
