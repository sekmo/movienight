require "rails_helper"

RSpec.feature "Friendships", type: :system do
  before(:each) do
    @tom   = create(:user)
    @jerry = create(:user, first_name: "jerry", last_name: "bomby", username: "jerry")

    login_as @tom, scope: :user
  end

  scenario "User can search for friends and send a friend request", js: true do
    visit user_path(@tom.id)

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
    visit user_path(@tom)
    expect(page).to have_content(@jerry.full_name)

    pending_friend_li = find("ul.pending-requests").find("li", text: @jerry.full_name)

    expect{
      pending_friend_li.click_on("Accept request")
    }.to change { @tom.reload.friends.size }.by(1)
  end
end
