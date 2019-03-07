require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe "relationships" do
    it { should have_many(:wishes) }
  end


  describe "validations" do
    it "is invalid without a title" do
      expect(build(:movie, title: nil)).to_not be_valid
    end

    it "is invalid without a tmdb_code" do
      expect(build(:movie, tmdb_code: nil)).to_not be_valid
    end

    it "is invalid with a duplicate tmdb_code" do
      create(:movie, tmdb_code: 42)
      expect(build(:movie, tmdb_code: 42)).to_not be_valid
    end
  end

  describe ".match_all_users" do
    let(:tom)   { create(:user) }
    let(:jerry) { create(:user) }
    let(:spike) { create(:user) }

    let(:movie_1) { create(:movie) }
    let(:movie_2) { create(:movie) }
    let(:movie_3) { create(:movie) }
    let(:movie_4) { create(:movie) }

    let!(:tom_wish1)   { create(:wish, movie: movie_1, user: tom) }
    let!(:jerry_wish1) { create(:wish, movie: movie_2, user: jerry) }
    let!(:spike_wish1) { create(:wish, movie: movie_3, user: spike) }

    let!(:tom_wish2)   { create(:wish, movie: movie_4, user: tom) }
    let!(:jerry_wish2) { create(:wish, movie: movie_4, user: jerry) }
    let!(:spike_wish2) { create(:wish, movie: movie_4, user: spike) }

    it "returns the movies that multiple users have in common" do
      expect(Movie.match_all_users([tom.id, jerry.id, spike.id])).to eq(
        complete_match: [movie_4],
        partial_match: [movie_1, movie_2, movie_3]
      )
    end
  end
end
