class Profile < ApplicationRecord
  belongs_to :user

  validates_presence_of :first_name, :last_name, :nickname
  validates :nickname, uniqueness: { case_sensitive: false }

  def full_name
    "#{first_name} #{last_name} (#{nickname})"
  end

  def self.search_by_full_name(term)
    return [] if term.blank?
    where("first_name ILIKE ?", "%#{term}%")
      .or(where("last_name ILIKE ?", "%#{term}%"))
      .or(where("nickname ILIKE ?", "%#{term}%"))
  end
end
