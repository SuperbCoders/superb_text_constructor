class CreateSuperbTextConstructorBlocks < ActiveRecord::Migration
  def change
    create_table :superb_text_constructor_blocks do |t|
      t.string :type
      t.string :blockable_type
      t.integer :blockable_id
      t.integer :position
      t.string :template
      t.text :data

      t.timestamps
    end
    add_index :superb_text_constructor_blocks, :type, name: 'superb_text_constructor_blocks_type_index'
    add_index :superb_text_constructor_blocks, [:blockable_type, :blockable_id], name: 'superb_text_constructor_blocks_blockable_index'
  end
end
