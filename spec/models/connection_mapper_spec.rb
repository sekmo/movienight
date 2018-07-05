require 'rails_helper'

RSpec.describe ConnectionMapper, type: :model do
  let(:francesco) { create(:user) }
  let(:chiara) { create(:user, :with_profile) }
  let(:andrew) { create(:user, :with_profile) }
  let(:mark) { create(:user, :with_profile) }
  let(:stranger) { create(:user, :with_profile) }
  let(:search_result_profiles) { [chiara.profile, andrew.profile, mark.profile, stranger.profile] }
  let(:connection_mapper) { ConnectionMapper.new(francesco, search_result_profiles) }

  before do
    Friendship.create!(sender: francesco, recipient: chiara).confirm!
    Friendship.create!(sender: francesco, recipient: andrew)
    Friendship.create!(sender: mark, recipient: francesco)
  end

  describe "#connections" do
    it "Returns the connections that the user has with the profiles" do
      expect(
        connection_mapper.connections
      ).to eq([
        {
          full_name: chiara.profile.full_name,
          user_id: chiara.id,
          type: :friend
        },
        {
          full_name: andrew.profile.full_name,
          user_id: andrew.id,
          type: :receiver
        },
        {
          full_name: mark.profile.full_name,
          user_id: mark.id,
          type: :requester,
          friendship: Friendship.find_by!(sender: mark, recipient: francesco),
        },
        {
          full_name: stranger.profile.full_name,
          user_id: stranger.id,
          type: :stranger
        }
      ])
    end
  end

  describe "#profiles_book" do
    it "Returns a profiles book" do
      expect(
        connection_mapper.send(:profiles_book)
      ).to eq({
        friends_prof_ids: [chiara.profile.id],
        friend_requesters_prof_ids: [mark.profile.id],
        friend_receivers_prof_ids: [andrew.profile.id],
      })
    end
  end

  describe "#connection_with" do
    it "Returns a friend connection" do
      expect(
        connection_mapper.send(:connection_with, chiara.profile)
      ).to eq({ type: :friend })
    end

    it "Returns a receiver connection" do
      expect(
        connection_mapper.send(:connection_with, andrew.profile)
      ).to eq({ type: :receiver })
    end


    it "Matches the profile of a user who sent us a friend request" do
      friendship = Friendship.find_by!(sender: mark, recipient: francesco)
      expect(
        connection_mapper.send(:connection_with, mark.profile)
      ).to eq({ type: :requester, friendship: friendship })
    end

    it "Matches the profile of an unrelated user" do
      expect(
        connection_mapper.send(:connection_with, stranger.profile)
      ).to eq({ type: :stranger })
    end
  end

end
