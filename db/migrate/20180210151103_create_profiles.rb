class CreateProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.string :nickname, null: false
      t.index  :nickname, unique: true
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.timestamps
    end

    add_foreign_key :profiles, :users, on_delete: :cascade
  end
end
