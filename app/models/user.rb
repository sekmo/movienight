class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :wishes, dependent: :destroy

  has_many :outgoing_friendships, class_name: "FriendshipRequest", foreign_key: "sender_id"
  has_many :outgoing_friends, through: :outgoing_friendships

  has_many :incoming_friendships, class_name: "FriendshipRequest", foreign_key: "recipient_id"
  has_many :incoming_friends, through: :incoming_friendships

  has_one :profile

  def ask_friendship(user)
    FriendshipRequest.create(sender: self, recipient: user)
  end

  def accept_friendship(user)
    friendship = incoming_friendships.find_by(sender: user)
    friendship.accept!
  end

  def decline_friendship(user)
    friendship = incoming_friendships.find_by(sender: user)
    friendship.destroy!
  end
end
