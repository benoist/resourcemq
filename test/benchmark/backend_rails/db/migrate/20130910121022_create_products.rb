class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.boolean :published
      t.integer :price

      t.timestamps
    end
  end
end
