class CopyProfilesAgain < ActiveRecord::Migration[5.1]
  def up
    batch_size = 10
    user_amount = User.count
    batches_amount = (user_amount / batch_size.to_f).ceil

    User.find_in_batches(batch_size: batch_size).with_index do |group, batch_num|
      say_with_time("Updated user batch #{(batch_num + 1)}/#{batches_amount}") do
        group.each do |user|
          if profile = (Profile.find_by(user_id: user.id))
            user.update!(
              first_name: profile.first_name,
              last_name: profile.last_name,
              username: profile.nickname,
              image_data: profile.image_data
            )
          end
        end
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
