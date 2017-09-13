class DropMoviesTable < ActiveRecord::Migration[5.1]
  def up
    drop_table :movies
    drop_table :movies_users
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
