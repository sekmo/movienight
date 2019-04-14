require 'rails_helper'

RSpec.describe "Pages", type: :system do
  scenario "should invite public users to register" do
    visit "/pages/welcome"
    expect(page).to have_content "Register and add your movies"
  end
end
