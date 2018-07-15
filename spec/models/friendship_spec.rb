require 'rails_helper'

RSpec.describe Friendship, type: :model do
  describe "relationships" do
    it { is_expected.to belong_to(:sender) }
    it { is_expected.to belong_to(:receiver) }
  end

  describe "#confirm!" do
    it "Fills the confirmation date" do
      friendship = build(:friendship)
      expect {
        friendship.confirm!
      }.to change { friendship.confirmation_date }.from(nil).to(be_truthy)
    end
  end
end
