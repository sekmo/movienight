class Movie < ApplicationRecord
  has_many :wishes, dependent: :destroy
  has_many :profiles, through: :wishes

  validates :tmdb_code, presence: true, uniqueness: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :title, presence: true

  # Return all the movies that are in all the watchlists of every specified profile
  def self.match_all_profiles(profile_ids)
    Movie.joins(:profiles).where(profiles: {id: profile_ids}).group(:id).having("COUNT(*) = ?", profile_ids.size)
  end
end
