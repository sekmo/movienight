require 'rails_helper'

RSpec.describe User, type: :model do
  describe "relationships" do
    it { should have_one(:profile) }
    it { should have_many(:wishes) } # Absolutely right

    it "is valid also without an associated profile" do
      expect(build(:user, profile: nil)).to be_valid
    end
  end

  describe "#ask_friendship" do
    it "creates a new friendship" do
      @tom   ||= create(:user)
      @jerry ||= create(:user)

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

  describe ".search_by_full_name" do
    let(:francesco) { create(:user) }
    let(:andrea) { create(:user) }
    let(:mario) { create(:user) }
    let(:adriano) { create(:user) }

    before do
      create(:profile, user: francesco, first_name: "Francesco", last_name: "Mari", nickname: "sekmo")
      create(:profile, user: andrea, first_name: "Andrea", last_name: "Rossi", nickname: "frank")
      create(:profile, user: mario, first_name: "Mario", last_name: "Franceschini", nickname: "marione")
      create(:profile, user: adriano, first_name: "Adriano", last_name: "Verdi", nickname: "adrian")
    end

    it "returns the profiles which first_name, last_name or nickname matches the term" do
      expect(User.search_by_full_name("fra")).to match_array([francesco, andrea, mario])
    end

    context "when the search term is nil" do
      it "returns an empty array" do
        expect(User.search_by_full_name(nil)).to eq([])
      end
    end

    context "when the search term is an emtpy string" do
      it "returns an empty array" do
        expect(User.search_by_full_name(nil)).to eq([])
      end
    end
  end
end
