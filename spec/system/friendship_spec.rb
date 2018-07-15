require "rails_helper"

RSpec.feature "Friendships", type: :feature do
  before(:each) do
    @tom   = create(:profile)
    @jerry = create(:profile)
    @spike = create(:profile)
    @jerry.ask_friendship(@tom)
    @spike.ask_friendship(@tom)
    login_as @tom.user, scope: :user
  end

  scenario "User can accept a pending friendship request" do
    visit profile_path(@tom)
    expect(page).to have_content(@jerry.full_name)
    pending_friend_li = find("ul.pending-requests").find("li", text: @jerry.full_name)

    pending_friend_li.click_on("Accept request")
    visit profile_path(@tom)

    friends_ul = find("ul.friends")
    pending_requests_ul = find("ul.pending-requests")
    expect(friends_ul).to have_content(@jerry.full_name)
    expect(pending_requests_ul).not_to have_content(@jerry.full_name)
  end
end
