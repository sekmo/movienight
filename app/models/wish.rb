class Wish < ApplicationRecord
  belongs_to :user
  belongs_to :cached_movie

  validates :user, presence: true
  validates :cached_movie, presence: true
end
