class CreateExports < ActiveRecord::Migration
  def change
    create_table :exports do |t|
      t.integer :user_id
      t.string :path
      t.timestamp :generated_at
      t.string :status
      t.integer :downloads, :default => 0

      t.timestamps
    end
  end
end
