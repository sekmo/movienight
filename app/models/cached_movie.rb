class CachedMovie < ApplicationRecord
  has_many :wishes, dependent: :destroy

  validates :tmdb_id, presence: true, numericality: { only_integer: true,
                                                      greater_than_or_equal_to: 0 }
  validates :title, presence: true
end
