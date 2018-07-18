require "rails_helper"

RSpec.feature "Friendships", type: :system do
  before(:each) do
    @tom   = create(:profile)
    @jerry = create(:profile, first_name: "jerry", last_name: "bomby", nickname: "jerry")
    login_as @tom.user, scope: :user
  end

  scenario "User can search for friends and send a friend request", js: true do
    visit profile_path(@tom)

    click_on("Add a new friend")
    fill_in "q", with: "jerry"
    click_on("Search")

    searched_friend_li = find("ul.friend-search-results").find("li", match: :first)

    expect{
      searched_friend_li.click_on("Send friend request")
    }.to change { @jerry.reload.friendship_requests.size }.by(1)
  end

  scenario "User can accept a pending friendship request" do
    @jerry.ask_friendship(@tom)
    visit profile_path(@tom)
    expect(page).to have_content(@jerry.full_name)

    pending_friend_li = find("ul.pending-requests").find("li", text: @jerry.full_name)

    expect{
      pending_friend_li.click_on("Accept request")
    }.to change { @tom.reload.friends.size }.by(1)
  end
end
