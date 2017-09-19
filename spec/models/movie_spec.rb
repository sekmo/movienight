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
end
