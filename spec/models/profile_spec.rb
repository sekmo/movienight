require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe "relationships" do
    it { is_expected.to belong_to(:user) }
    it { should have_many(:wishes) } # Absolutely right
  end

  describe "validations" do
    it "is not valid without an associated user" do
      expect(build(:profile, user: nil)).to_not be_valid
    end
  end

  describe ".search_by_full_name" do
    let(:francesco) { create(:profile, first_name: "Francesco", last_name: "Mari", nickname: "sekmo") }
    let(:andrea) { create(:profile, first_name: "Andrea", last_name: "Rossi", nickname: "frank") }
    let(:mario) { create(:profile, first_name: "Mario", last_name: "Franceschini", nickname: "marione") }
    let(:adriano) { create(:profile, first_name: "Adriano", last_name: "Verdi", nickname: "adrian") }

    it "returns the profiles which first_name, last_name or nickname matches the term" do
      expect(Profile.search_by_full_name("fra")).to match_array([francesco, andrea, mario])
    end

    context "when the search term is nil" do
      it "returns an empty array" do
        expect(Profile.search_by_full_name(nil)).to eq([])
      end
    end

    context "when the search term is an emtpy string" do
      it "returns an empty array" do
        expect(Profile.search_by_full_name(nil)).to eq([])
      end
    end
  end

  describe "#ask_friendship" do
    it "creates a new friendship" do
      @tom   ||= create(:profile)
      @jerry ||= create(:profile)

      expect {
        @tom.ask_friendship(@jerry)
      }.to change { @jerry.reload.friendship_requesters.include?(@tom) }.from(false).to(true)
    end
  end

  describe "#friends" do
    #TODO
    it "returns all the friends of the user"
  end

  describe "#friendship_requests" do
    #TODO
    it "returns the pending friendship requests"
  end

  describe "#friendship_requesters" do
    #TODO
    it "returns the users that made a friendship request to the user"
  end
end
