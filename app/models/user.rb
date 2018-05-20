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
    Friendship.create(sender: self, recipient: user)
  end

  def friends
    friends = outgoing_friendships.select(&:confirmed?).map(&:recipient) +
                incoming_friendships.select(&:confirmed?).map(&:sender)
  end

  def friendship_requests
    incoming_friendships.select(&:pending?)
  end

  def friendship_requesters
    #TODO add a join here - avoid select?
    friendship_requests.map(&:sender)
  end
end
