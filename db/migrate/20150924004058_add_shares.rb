class AddShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.references :category
      t.references :user
      t.timestamps null: false
    end
  end
end
