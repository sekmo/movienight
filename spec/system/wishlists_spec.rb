require "rails_helper"

RSpec.describe "Managing the wishlist", type: :system do
  let(:user) { create(:user, :with_profile) }
  let(:profile) { user.profile }

  before(:each) do
    login_as user, scope: :user
  end

  scenario "User cannot search for a movie if she doesn't have a profile" do
    profile.destroy
    visit new_wish_path
    expect(current_path).to eql(new_profile_path)
    expect(page).to have_content "Create your social profile to continue"
  end

  scenario "User adds a movie to her wishlist" do
    visit new_wish_path
    fill_in "search", with: "kill bill"

    click_on "Search"

    expect(page).to have_content("Kill Bill: Vol. 1")

    movie_span = page.all("span", text: "Kill Bill: Vol. 1").first
    movie_span_container = movie_span.first(:xpath, ".//..")
    expect {
      movie_span_container.click_on("Add to wishlist")
    }.to change { profile.wishes.count }.by(1)
  end

  scenario "User removes a movie from her wishlist", js: true do
    movie = create(:movie)
    create(:wish, movie: movie, profile: profile)
    visit wishes_path
    expect(page).to have_content movie.title

    movie_li = find("li", text: movie.title)

    expect(profile.wishes.count).to eq(1)

    movie_li.click_on("Remove movie")
    expect(page).not_to have_content movie.title
    expect(profile.wishes.count).to eq(0)

    # TODO Why doesn't it work?
    # expect {
    #   movie_li.click_on("Remove movie")
    #   wait_for_ajax
    # }.to change { @user.reload.wishes.count }.from(1).to(0)
  end
end
