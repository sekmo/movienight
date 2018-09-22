class Profile < ApplicationRecord
  validates_presence_of :first_name, :last_name, :nickname
  validates :nickname, uniqueness: { case_sensitive: false }

  belongs_to :user
  has_many :wishes, dependent: :destroy
  has_many :movies, through: :wishes
  has_many :outgoing_friendships, class_name: "Friendship", foreign_key: "sender_id"
  has_many :incoming_friendships, class_name: "Friendship", foreign_key: "receiver_id"

  include ImageUploader[:image]

  def full_name
    "#{first_name} #{last_name} (#{nickname})"
  end

  def initials
    "#{first_name[0]}#{last_name[0]}"
  end

  def self.search_by_full_name(term)
    return [] if term.blank?
    where("first_name ILIKE ?", "%#{term}%")
      .or(where("last_name ILIKE ?", "%#{term}%"))
      .or(where("nickname ILIKE ?", "%#{term}%"))
  end

  def ask_friendship(profile)
    Friendship.create!(sender: self, receiver: profile)
  rescue ActiveRecord::RecordInvalid
    return false
  end

  def friends_ids
    outgoing_friendships.select(&:confirmed?).pluck(:receiver_id) +
      incoming_friendships.select(&:confirmed?).pluck(:sender_id)
  end

  def friends
    Profile.where(id: friends_ids)
  end

  def friendship_requests
    incoming_friendships.select(&:pending?)
  end

  def friendship_requesters_ids
    incoming_friendships.select(&:pending?).pluck(:sender_id)
  end

  def friendship_requesters
    Profile.where(id: friendship_requesters_ids)
  end

  def friendship_receivers_ids
    outgoing_friendships.select(&:pending?).pluck(:receiver_id)
  end

  def friendship_receivers
    Profile.where(id: friendship_receivers_ids)
  end
end
