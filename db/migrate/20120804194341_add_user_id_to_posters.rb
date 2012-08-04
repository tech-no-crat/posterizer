class AddUserIdToPosters < ActiveRecord::Migration
  def change
    add_column :posters, :user_id, :integer
  end
end
