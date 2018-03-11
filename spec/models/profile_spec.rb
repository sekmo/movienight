require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe "relationships" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it "is not valid without an associated user" do
      expect(build(:profile, user: nil)).to_not be_valid
    end
  end
end
