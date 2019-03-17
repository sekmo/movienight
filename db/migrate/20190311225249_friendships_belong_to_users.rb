class FriendshipsBelongToUsers < ActiveRecord::Migration[5.1]
  def up
    remove_foreign_key "friendships", column: "receiver_id"
    remove_foreign_key "friendships", column: "sender_id"

    # Replace profiles ids with users ids
    batch_size = 10
    wish_amount = Friendship.count
    batches_amount = (wish_amount / batch_size.to_f).ceil

    Friendship.find_in_batches(batch_size: batch_size).with_index do |group, batch_num|
      say_with_time("Updated wish batch #{(batch_num + 1)}/#{batches_amount}") do
        group.each do |friendship|
          # at this point the column name was changed from profile_id to user_id
          # so user_id is actually the profile_id
          friendship.update!(
            receiver_id: Profile.find(friendship.receiver_id).user_id,
            sender_id: Profile.find(friendship.sender_id).user_id
          )
        end
      end
    end

    add_foreign_key "friendships", "users", column: "receiver_id"
    add_foreign_key "friendships", "users", column: "sender_id"
  end

  def down
    remove_foreign_key "friendships", column: "receiver_id"
    remove_foreign_key "friendships", column: "sender_id"

    # Replace profiles ids with users ids
    batch_size = 10
    wish_amount = Friendship.count
    batches_amount = (wish_amount / batch_size.to_f).ceil

    Friendship.find_in_batches(batch_size: batch_size).with_index do |group, batch_num|
      say_with_time("Updated wish batch #{(batch_num + 1)}/#{batches_amount}") do
        group.each do |friendship|
          # at this point the column name was changed from profile_id to user_id
          # so user_id is actually the profile_id
          friendship.update!(
            receiver_id: Profile.find_by!(user_id: friendship.receiver_id).id,
            sender_id: Profile.find_by!(user_id: friendship.sender_id).id
          )
        end
      end
    end

    add_foreign_key "friendships", "profiles", column: "receiver_id"
    add_foreign_key "friendships", "profiles", column: "sender_id"
  end
end
