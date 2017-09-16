require 'rails_helper'

RSpec.describe Wish, type: :model do
  describe "validations" do
    it "is invalid without a movie_id" do
      expect(build(:wish, movie: nil)).to_not be_valid
    end

    it "is invalid without a user_id" do
      expect(build(:wish, user: nil)).to_not be_valid
    end

    it "is invalid with a duplicate user_id and movie_id pair" do
      create(:wish)
      expect(build(:wish)).to_not be_valid
    end
  end
end
