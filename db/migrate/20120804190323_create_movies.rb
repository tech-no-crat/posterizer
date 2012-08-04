class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :tmdb_id
      t.string :title
      t.string :release

      t.timestamps
    end
  end
end
