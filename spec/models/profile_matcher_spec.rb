require 'rails_helper'

RSpec.describe ProfileMatcher, type: :model do
  describe "#match" do
    let(:francesco) { create(:user) }
    let(:chiara) { create(:user, :with_profile) }
    let(:profile_matcher) { ProfileMatcher.new(francesco) }

    it "Matches the profile of a friend" do
      Friendship.create!(sender: francesco, recipient: chiara).confirm!
      expect(
        profile_matcher.match(chiara.profile)
      ).to eq({ match_kind: :friend })
    end

    it "Matches the profile of a user we sent a friend request to" do
      Friendship.create!(sender: francesco, recipient: chiara)
      expect(
        profile_matcher.match(chiara.profile)
      ).to eq({ match_kind: :receiver })
    end

    it "Matches the profile of a user who sent us a friend request" do
      friendship = Friendship.create!(sender: chiara, recipient: francesco)
      expect(
        profile_matcher.match(chiara.profile)
      ).to eq({ match_kind: :requester, friendship: friendship })
    end

    it "Matches the profile of an unrelated user" do
      expect(
        profile_matcher.match(chiara.profile)
      ).to eq({ match_kind: :stranger })
    end
  end
end
