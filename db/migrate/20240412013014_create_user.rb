class CreateUser < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :first_name, null: false, default: ""
      t.string :last_name, null: false, default: ""
      t.string :email, null: false
      t.integer :role, default: 0, null: false
      t.date :date_of_birth, null: false

      t.timestamps
    end
  end
end
