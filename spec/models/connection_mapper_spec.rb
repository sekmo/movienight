require 'rails_helper'

RSpec.describe ConnectionMapper, type: :model do
  let(:francesco) { create(:user, :with_profile) }
  let(:chiara) { create(:user, :with_profile) }
  let(:andrew) { create(:user, :with_profile) }
  let(:mark) { create(:user, :with_profile) }
  let(:stranger) { create(:user, :with_profile) }
  let(:connection_mapper) { ConnectionMapper.new(francesco, [chiara, andrew, mark, stranger]) }

  before do
    Friendship.create!(sender: francesco, receiver: chiara).confirm!
    Friendship.create!(sender: francesco, receiver: andrew)
    Friendship.create!(sender: mark, receiver: francesco)
  end

  describe "#connections" do
    it "Returns the connections that the user has with the other users" do
      expect(
        connection_mapper.connections
      ).to eq([
        {
          full_name: chiara.profile.full_name,
          user: chiara,
          type: :friend
        },
        {
          full_name: andrew.profile.full_name,
          user: andrew,
          type: :receiver
        },
        {
          full_name: mark.profile.full_name,
          user: mark,
          type: :requester,
          friendship: Friendship.find_by!(sender: mark, receiver: francesco),
        },
        {
          full_name: stranger.profile.full_name,
          user: stranger,
          type: :stranger
        }
      ])
    end
  end

  describe "#users_book" do
    it "Returns a users book" do
      expect(
        connection_mapper.send(:users_book)
      ).to eq({
        friends_ids: [chiara.id],
        friend_requesters_ids: [mark.id],
        friend_receivers_ids: [andrew.id],
      })
    end
  end

  describe "#connection_with" do
    it "Returns a friend connection" do
      expect(
        connection_mapper.send(:connection_with, chiara)
      ).to eq({ type: :friend })
    end

    it "Returns a receiver connection" do
      expect(
        connection_mapper.send(:connection_with, andrew)
      ).to eq({ type: :receiver })
    end


    it "Matches the user of a user who sent us a friend request" do
      friendship = Friendship.find_by!(sender: mark, receiver: francesco)
      expect(
        connection_mapper.send(:connection_with, mark)
      ).to eq({ type: :requester, friendship: friendship })
    end

    it "Matches the user of an unrelated user" do
      expect(
        connection_mapper.send(:connection_with, stranger)
      ).to eq({ type: :stranger })
    end
  end

end
