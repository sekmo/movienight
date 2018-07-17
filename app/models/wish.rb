class Wish < ApplicationRecord
  belongs_to :profile
  belongs_to :movie

  validates :profile, presence: true
  validates :movie, presence: true, uniqueness: { scope: [:profile_id] }

  def self.find_by_profile(profile)
    where(profile: profile)
  end
end
