class Profile < ApplicationRecord
  validates_presence_of :first_name, :last_name, :nickname
  validates :nickname, uniqueness: { case_sensitive: false }

  belongs_to :user
  has_many :movies, through: :wishes

  include ImageUploader[:image]

  def full_name
    "#{first_name} #{last_name} (#{nickname})"
  end

  def initials
    "#{first_name[0]}#{last_name[0]}"
  end
end
