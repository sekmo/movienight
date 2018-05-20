class Profile < ApplicationRecord
  belongs_to :user

  validates_presence_of :first_name, :last_name, :nickname
  validates :nickname, uniqueness: { case_sensitive: false }

  def full_name
    "#{first_name} #{last_name} (#{nickname})"
  end
end
