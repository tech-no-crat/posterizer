class AddPosterWidthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :poster_width, :integer
  end
end
