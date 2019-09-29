class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, omniauth_providers: [:google_oauth2]

  include ImageUploader[:image]

  has_many :wishes, dependent: :destroy
  has_many :outgoing_friendships, class_name: "Friendship", foreign_key: "sender_id", dependent: :destroy
  has_many :incoming_friendships, class_name: "Friendship", foreign_key: "receiver_id", dependent: :destroy

  validates_presence_of :first_name, :last_name, :username
  validates :username, uniqueness: { case_sensitive: false }

  def self.from_omniauth(access_token)
    data = access_token.info
    if user = User.where(:provider => access_token.provider, :uid => access_token.uid).first
    elsif user = User.where(:email => access_token.info.email).first
      user.update!(:provider => access_token.provider, :uid => access_token.uid)
    else
      user = User.new(
        provider: access_token.provider,
        uid: access_token.uid,
        email: data["email"],
        first_name: data['first_name'],
        last_name: data['last_name'],
      )
    end

    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.google_data"]
        user.email = data["info"]["email"] if user.email.blank?
        user.first_name = data["info"]["first_name"] if user.first_name.blank?
        user.last_name = data["info"]["last_name"] if user.last_name.blank?
        user.provider = data["provider"] if user.provider.blank?
        user.uid = data["uid"] if user.uid.blank?
      end
    end
  end

  def self.search_by_full_name(term)
    return [] if term.blank?
    where("users.first_name ILIKE :term OR last_name ILIKE :term OR username ILIKE :term",
      { term: "%#{term}%" }
    )
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_name_with_nickname
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

  def wish_from_movie?(movie)
    wishes.includes(:movie).find_by(movie: movie)
  end
end
