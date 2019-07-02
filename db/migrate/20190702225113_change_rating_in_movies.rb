class ChangeRatingInMovies < ActiveRecord::Migration[5.1]
  def up
    change_column :movies, :rating, :decimal, :precision => 3, :scale => 1
  end

  def down
    change_column :movies, :rating, :decimal, :precision => 2, :scale => 1
  end
end
