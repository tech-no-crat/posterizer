class AddIndextoUserHandle < ActiveRecord::Migration
  def up
    add_index :users, :handle
  end

  def down
    remove_index :users, :handle
  end
end
