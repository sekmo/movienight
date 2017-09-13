class CreateWishes < ActiveRecord::Migration[5.1]
  def change
    create_table :wishes do |t|
      t.references :user, foreign_key: true, null: false
      t.references :cached_movie, foreign_key: true, null: false

      t.timestamps
    end
  end
end
