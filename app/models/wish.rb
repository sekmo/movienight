class Wish < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  validates :user, presence: true
  validates :movie, presence: true

  def self.find_by_user(user)
    where(user: user)
  end
end
