class CreateEquipments < ActiveRecord::Migration[7.1]
  def change
    create_table :equipment do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.integer :location, null: false
      t.boolean :is_broken, null: false, default: false

      t.timestamps
    end
  end
end
