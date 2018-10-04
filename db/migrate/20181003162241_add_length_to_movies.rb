class AddLengthToMovies < ActiveRecord::Migration[5.1]
  def change
    add_column :movies, :length, :integer
    add_column :movies, :directors, :json
    add_column :movies, :rating, :decimal, precision: 2, scale: 1
    add_column :movies, :year, :integer
  end
end
