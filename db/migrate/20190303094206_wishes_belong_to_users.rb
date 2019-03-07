class WishesBelongToUsers < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :wishes, :profiles
    rename_column :wishes, :profile_id, :user_id
    add_foreign_key :wishes, :users

    # Set the user id in place of the profile id for every wish
    batch_size = 10
    wish_amount = Wish.count
    batches_amount = (wish_amount / batch_size.to_f).ceil

    Wish.find_in_batches(batch_size: batch_size).with_index do |group, batch_num|
      say_with_time("Updated wish batch #{(batch_num + 1)}/#{batches_amount}") do
        group.each do |wish|
          wish.update!(
            # at this point the column name was changed from profile_id to user_id
            # so user_id is actually the profile_id
            user_id: Profile.find(wish.user_id).user_id,
          )
        end
      end
    end


  end
end
