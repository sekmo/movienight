class MoveFriendRequestsToProfiles < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :friendships, column: :sender_id
    remove_foreign_key :friendships, column: :recipient_id
    rename_column :friendships, :recipient_id, :receiver_id

    add_foreign_key :friendships, :profiles, column: :receiver_id
    add_foreign_key :friendships, :profiles, column: :sender_id
  end
end
