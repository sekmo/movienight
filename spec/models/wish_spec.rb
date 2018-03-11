require 'rails_helper'

RSpec.describe Wish, type: :model do
  describe "relationships" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:movie) }
  end

  describe "validations" do
    it "is invalid without a movie_id" do
      expect(build(:wish, movie: nil)).to_not be_valid
    end

    it "is invalid without a user_id" do
      expect(build(:wish, user: nil)).to_not be_valid
    end

    it "is invalid with a duplicate user_id/movie_id pair" do
      wish  = create(:wish)
      wish2 = build(:wish, movie: wish.movie, user: wish.user)
      expect(wish2).to_not be_valid
    end
  end

  describe ".find_by_user" do
    let(:tom)   { create(:user) }
    let(:jerry) { create(:user) }
    let(:spike) { create(:user) }
    let(:tom_wish1)  { create(:wish, user: tom) }
    let(:tom_wish2)  { create(:wish, user: tom) }
    let(:tom_wish3)  { create(:wish, user: tom) }
    let(:jerry_wish) { create(:wish, user: jerry) }

    context "when a match is found" do
      it "returns the wishes that belong to the user" do
        expect(Wish.find_by_user(tom)).to match_array([tom_wish1, tom_wish2, tom_wish3])
      end

      it "doesn't return the wishes that belong other users" do
        expect(Wish.find_by_user(tom)).to_not include(jerry_wish)
      end
    end

    context "when no match is found" do
      it "returns an empty collection" do
        expect(Wish.find_by_user(spike)).to be_empty
      end
    end
  end
end
