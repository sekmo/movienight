class AddOriginalTitleAndPlotToMovies < ActiveRecord::Migration[5.1]
  def change
    add_column :movies, :original_title, :string
    add_column :movies, :plot, :string
  end
end
