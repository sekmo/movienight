class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include ImageUploader[:image]

  has_many :wishes, dependent: :destroy
  has_many :outgoing_friendships, class_name: "Friendship", foreign_key: "sender_id"
  has_many :incoming_friendships, class_name: "Friendship", foreign_key: "receiver_id"

  validates_presence_of :first_name, :last_name, :username
  validates :username, uniqueness: { case_sensitive: false }

  def self.search_by_full_name(term)
    return [] if term.blank?
    where("users.first_name ILIKE :term OR last_name ILIKE :term OR username ILIKE :term",
      { term: "%#{term}%" }
    )
  end

  def full_name
    "#{first_name} #{last_name} (#{username})"
  end

  def initials
    "#{first_name[0]}#{last_name[0]}"
  end

  def ask_friendship(user)
    Friendship.create!(sender: self, receiver: user)
  # the record is invalid if there's already a friendship request with the same sender and receiver
  rescue ActiveRecord::RecordInvalid
    return false
  end

  def friends_ids
    outgoing_friendships.select(&:confirmed?).pluck(:receiver_id) +
      incoming_friendships.select(&:confirmed?).pluck(:sender_id)
  end

  def friends
    self.class.where(id: friends_ids)
  end

  def friendship_requests
    incoming_friendships.select(&:pending?)
  end

  def friendship_requesters
    self.class.where(id: friendship_requesters_ids)
  end

  def friendship_receivers
    self.class.where(id: friendship_receivers_ids)
  end

  def friendship_requesters_ids
    incoming_friendships.select(&:pending?).pluck(:sender_id)
  end

  def friendship_receivers_ids
    outgoing_friendships.select(&:pending?).pluck(:receiver_id)
  end
end
