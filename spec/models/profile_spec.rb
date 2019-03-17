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

  describe  "initials" do
    it "returns the initials of the profile" do
      profile = build(:profile, first_name: "Gegio", last_name: "Stockhausen")
      expect(profile.initials).to eq("GS")
    end
  end
end
