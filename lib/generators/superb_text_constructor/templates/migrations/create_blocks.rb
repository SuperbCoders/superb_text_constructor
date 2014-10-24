class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.string :blockable_type
      t.integer :blockable_id
      t.integer :position
      t.string :template
      t.text :data

      t.timestamps
    end
    add_index :blocks, [:blockable_type, :blockable_id]
  end
end
