class Friendship < ApplicationRecord
  belongs_to :sender, :class_name => "Profile"
  belongs_to :receiver, :class_name => "Profile"

  validates :sender_id, presence: true, uniqueness: { scope: [:receiver_id] }
  validates :receiver_id, presence: true

  def confirmed?
    confirmation_date.present?
  end

  def pending?
    !confirmed?
  end

  def confirm!
    update_attributes(confirmation_date: DateTime.now)
  end
end
