class CreateMovies < ActiveRecord::Migration[5.1]
  def change
    create_table :movies do |t|
      t.integer :tmdb_code
      t.string :title
      t.timestamps
      t.index :tmdb_code, unique: true
    end
  end
end
