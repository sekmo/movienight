class CreateWishes < ActiveRecord::Migration[5.1]
  def change
    create_table :wishes do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.references :movie, null: false, foreign_key: { on_delete: :cascade }
      t.index [:movie_id, :user_id], unique: true
      t.index [:user_id, :movie_id]
      t.timestamps
    end
  end
end
