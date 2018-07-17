require 'rails_helper'

RSpec.describe User, type: :model do
  describe "relationships" do
    it { should have_one(:profile) }

    it "is valid also without an associated profile" do
      expect(build(:user, profile: nil)).to be_valid
    end
  end
end
