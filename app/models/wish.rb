class Wish < ApplicationRecord
  belongs_to :user
  belongs_to :cached_movie

  validates :user, presence: true
  validates :cached_movie, presence: true

  def self.find_by_user(user)
    where(user: user)
  end
end
