class CreateFriendshipRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :friendship_requests do |t|
      t.integer :sender_id, null: false, index: true
      t.integer :recipient_id, null: false, index: true
      t.datetime :accepted_date

      t.timestamps
    end

    add_foreign_key :friendship_requests, :users, column: :sender_id
    add_foreign_key :friendship_requests, :users, column: :recipient_id
  end
end
