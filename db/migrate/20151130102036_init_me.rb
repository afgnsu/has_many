class InitMe < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name

      t.timestamps null: false
    end
    create_table :item_children do |t|
      t.integer :item_id
      t.integer :age , :limit => 1
      t.string  :name

      t.timestamps null: false
    end
  end
end
