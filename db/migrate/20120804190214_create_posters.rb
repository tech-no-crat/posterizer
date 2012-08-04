class CreatePosters < ActiveRecord::Migration
  def change
    create_table :posters do |t|
      t.string :url
      t.integer :order
      t.integer :movie_id

      t.timestamps
    end
  end
end
