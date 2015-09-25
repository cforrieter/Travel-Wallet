class AddCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.text :files, array: true, default: []
      t.references :user
      t.timestamps null: false
    end
  end
end
