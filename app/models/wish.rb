class Wish < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  validates :user, presence: true
  validates :movie, presence: true, uniqueness: { scope: [:user_id] }

  def self.find_by_user(user)
    where(user: user)
  end
end
