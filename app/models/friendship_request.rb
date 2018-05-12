class FriendshipRequest < ApplicationRecord
  belongs_to :sender, :class_name => "User"
  belongs_to :recipient, :class_name => "User"

  validates :sender_id, presence: true, uniqueness: { scope: [:recipient_id] }
  validates :recipient_id, presence: true

  def accepted?
    accepted_date.present?
  end

  def accept!
    update_attributes(accepted_date: DateTime.now)
  end
end
