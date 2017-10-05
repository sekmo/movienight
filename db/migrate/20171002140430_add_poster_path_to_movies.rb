class AddPosterPathToMovies < ActiveRecord::Migration[5.1]
  def change
    add_column :movies, :poster_path, :string
  end
end
