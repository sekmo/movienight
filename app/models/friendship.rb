class Friendship < ApplicationRecord
  belongs_to :sender, :class_name => "User"
  belongs_to :receiver, :class_name => "User"

  validates :sender_id, presence: true
  # TODO see if we can do this at database level
  validates :receiver_id, presence: true, uniqueness: { scope: [:sender_id] }

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
