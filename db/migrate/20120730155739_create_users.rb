class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :handle
      t.string :name

      t.timestamps
    end
  end
end
