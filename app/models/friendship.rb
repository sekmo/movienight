class Friendship < ApplicationRecord
  belongs_to :sender, :class_name => "User"
  belongs_to :recipient, :class_name => "User"

  validates :sender_id, presence: true, uniqueness: { scope: [:recipient_id] }
  validates :recipient_id, presence: true

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
