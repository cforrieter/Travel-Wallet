class AddDocumentsTable < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :category
      t.string :file
      t.timestamps null: false
    end
  end
end
