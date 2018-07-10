require "rails_helper"

RSpec.feature "Friendships", type: :feature do
  before(:each) do
    @tom   = create(:user, :with_profile)
    @jerry = create(:user, :with_profile)
    @spike = create(:user, :with_profile)
    @jerry.ask_friendship(@tom)
    @spike.ask_friendship(@tom)
    login_as @tom, scope: :user
  end

  scenario "User can accept a pending friendship request" do
    visit profile_path(@tom.profile)
    expect(page).to have_content(@jerry.profile.full_name)
    pending_friend_li = find("ul.pending-requests").find("li", text: @jerry.profile.full_name)

    pending_friend_li.click_on("Accept request")
    visit profile_path(@tom.profile)

    friends_ul = find("ul.friends")
    pending_requests_ul = find("ul.pending-requests")
    expect(friends_ul).to have_content(@jerry.profile.full_name)
    expect(pending_requests_ul).not_to have_content(@jerry.profile.full_name)
  end
end
