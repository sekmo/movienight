class WishesBelongToProfile < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :wishes, column: :user_id
    rename_column :wishes, :user_id, :profile_id

    add_foreign_key :wishes, :profiles
  end
end
