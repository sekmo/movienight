class CreateCachedMovies < ActiveRecord::Migration[5.1]
  def change
    create_table :cached_movies do |t|
      t.integer :tmdb_id
      t.string :title

      t.timestamps
    end
  end
end
