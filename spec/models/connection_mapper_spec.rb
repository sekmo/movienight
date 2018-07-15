require 'rails_helper'

RSpec.describe ConnectionMapper, type: :model do
  let(:francesco) { create(:profile) }
  let(:chiara) { create(:profile) }
  let(:andrew) { create(:profile) }
  let(:mark) { create(:profile) }
  let(:stranger) { create(:profile) }
  let(:search_result_profiles) { [chiara, andrew, mark, stranger] }
  let(:connection_mapper) { ConnectionMapper.new(francesco, search_result_profiles) }

  before do
    Friendship.create!(sender: francesco, receiver: chiara).confirm!
    Friendship.create!(sender: francesco, receiver: andrew)
    Friendship.create!(sender: mark, receiver: francesco)
  end

  describe "#connections" do
    it "Returns the connections that the user has with the profiles" do
      expect(
        connection_mapper.connections
      ).to eq([
        {
          full_name: chiara.full_name,
          profile: chiara,
          type: :friend
        },
        {
          full_name: andrew.full_name,
          profile: andrew,
          type: :receiver
        },
        {
          full_name: mark.full_name,
          profile: mark,
          type: :requester,
          friendship: Friendship.find_by!(sender: mark, receiver: francesco),
        },
        {
          full_name: stranger.full_name,
          profile: stranger,
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


    it "Matches the profile of a user who sent us a friend request" do
      friendship = Friendship.find_by!(sender: mark, receiver: francesco)
      expect(
        connection_mapper.send(:connection_with, mark)
      ).to eq({ type: :requester, friendship: friendship })
    end

    it "Matches the profile of an unrelated user" do
      expect(
        connection_mapper.send(:connection_with, stranger)
      ).to eq({ type: :stranger })
    end
  end

end
