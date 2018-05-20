require 'rails_helper'

RSpec.describe User, type: :model do
  describe "relationships" do
    it { should have_many(:wishes) } # Absolutely right
    it { should have_one(:profile) }

    it "is valid also without an associated profile" do
      expect(build(:user, profile: nil)).to be_valid
    end
  end

  describe "#ask_friendship" do
    it "creates a new friendship" do
      @tom   ||= create(:user, :with_profile)
      @jerry ||= create(:user, :with_profile)

      expect {
        @tom.ask_friendship(@jerry)
      }.to change { @jerry.reload.friendship_requesters.include?(@tom) }.from(false).to(true)
    end
  end

  describe "#friends" do
    #TODO
    it "returns all the friends of the user"
  end

  describe "#friendship_requests" do
    #TODO
    it "returns the pending friendship requests"
  end

  describe "#friendship_requesters" do
    #TODO
    it "returns the users that made a friendship request to the user"
  end
end
