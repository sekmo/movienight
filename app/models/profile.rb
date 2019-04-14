class Profile < ApplicationRecord
  validates_presence_of :first_name, :last_name, :nickname
  validates :nickname, uniqueness: { case_sensitive: false }

  belongs_to :user

  include ImageUploader[:image]
end
