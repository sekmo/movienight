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

  def friends
    Rails.logger.debug("User#friends")
    outgoing_friends_ids = outgoing_friendships.select(&:confirmed?).pluck(:recipient_id)
    incoming_friends_ids = incoming_friendships.select(&:confirmed?).pluck(:sender_id)
    User.where(id: outgoing_friends_ids + incoming_friends_ids)
  end

  def friendship_requests
    Rails.logger.debug("User#friendship_requests")
    incoming_friendships.select(&:pending?)
  end

  def friendship_requesters
    Rails.logger.debug("User#friendship_requesters")
    incoming_friendships.select(&:pending?).map(&:sender)
  end

  def friendship_receivers
    Rails.logger.debug("User#friendship_receivers")
    outgoing_friendships.select(&:pending?).map(&:recipient)
  end
end
