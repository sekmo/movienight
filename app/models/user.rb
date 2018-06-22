class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :wishes, dependent: :destroy

  has_many :outgoing_friendships, class_name: "Friendship", foreign_key: "sender_id"
  has_many :incoming_friendships, class_name: "Friendship", foreign_key: "recipient_id"

  has_one :profile

  def ask_friendship(user)
    Friendship.create!(sender: self, recipient: user)
  rescue ActiveRecord::RecordInvalid
    return false
  end

  def friends_ids
    outgoing_friendships.select(&:confirmed?).pluck(:recipient_id) +
      incoming_friendships.select(&:confirmed?).pluck(:sender_id)
  end

  def friends
    User.where(id: friends_ids)
  end

  def friendship_requests
    incoming_friendships.select(&:pending?)
  end

  def friendship_requesters_ids
    incoming_friendships.select(&:pending?).pluck(:sender_id)
  end

  def friendship_requesters
    User.where(id: friendship_requesters_ids)
  end

  def friendship_receivers_ids
    outgoing_friendships.select(&:pending?).pluck(:recipient_id)
  end

  def friendship_receivers
    User.where(id: friendship_receivers_ids)
  end
end
