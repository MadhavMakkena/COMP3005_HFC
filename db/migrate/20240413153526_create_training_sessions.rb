class CreateTrainingSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :training_sessions do |t|
      t.integer :name, null: false, default: 0
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.references :room_booking, null: false, foreign_key: true

      t.timestamps
    end
  end
end
