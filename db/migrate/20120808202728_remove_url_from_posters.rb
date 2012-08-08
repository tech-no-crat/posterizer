class RemoveUrlFromPosters < ActiveRecord::Migration
  def up
    remove_column :posters, :url
  end

  def down
    add_column :posters, :url, :string
  end
end
