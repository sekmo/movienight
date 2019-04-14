require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "is not valid without a first name" do
      expect(build(:user, first_name: nil)).not_to be_valid
    end

    it "is not valid without a last name" do
      expect(build(:user, last_name: nil)).not_to be_valid
    end

    it "is not valid without a username" do
      expect(build(:user, username: nil)).not_to be_valid
    end
  end

  describe "relationships" do
    it { should have_many(:wishes) } # Absolutely right
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
    let(:francesco) { create(:user, first_name: "Francesco", last_name: "Mari", username: "sekmo") }
    let(:miglio) { create(:user, first_name: "Andrea", last_name: "Migliorelli", username: "miglio") }
    let(:siso) { create(:user, first_name: "Pierpaolo", last_name: "Seri", username: "siso") }
    let(:saverio) { create(:user, first_name: "Saverio", last_name: "Verdicchio", username: "saverio") }

    it "returns all the friends of the user" do
      create(:friendship, sender: francesco, receiver: miglio, confirmation_date: DateTime.now)
      create(:friendship, sender: francesco, receiver: siso, confirmation_date: DateTime.now)
      create(:friendship, sender: francesco, receiver: saverio, confirmation_date: DateTime.now)

      expect(francesco.friends).to match_array([miglio, siso, saverio])
    end
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
    let(:francesco) { create(:user, first_name: "Francesco", last_name: "Mari", username: "sekmo") }
    let(:andrea) { create(:user, first_name: "Andrea", last_name: "Rossi", username: "frank") }
    let(:mario) { create(:user, first_name: "Mario", last_name: "Franceschini", username: "marione") }
    let(:adriano) { create(:user, first_name: "Adriano", last_name: "Verdi", username: "adrian") }

    context "when the search term is a string" do
      it "returns the users which first_name, last_name or nickname matches the term" do
        expect(User.search_by_full_name("fra")).to match_array([francesco, andrea, mario])
      end
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
