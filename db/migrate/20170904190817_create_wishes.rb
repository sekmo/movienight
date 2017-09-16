class CreateWishes < ActiveRecord::Migration[5.1]
  def change
    create_table :wishes do |t|
      t.references :user, foreign_key: true, null: false
      t.references :movie, foreign_key: true, null: false
      t.index [:movie_id, :user_id], unique: true
      t.index [:user_id, :movie_id]
      t.timestamps
    end
  end
end
