class CreateFriendships < ActiveRecord::Migration[5.1]
  def change
    create_table :friendships do |t|
      t.integer :sender_id, null: false, index: true
      t.integer :recipient_id, null: false, index: true
      t.datetime :confirmation_date

      t.timestamps
    end

    add_foreign_key :friendships, :users, column: :sender_id
    add_foreign_key :friendships, :users, column: :recipient_id
  end
end
