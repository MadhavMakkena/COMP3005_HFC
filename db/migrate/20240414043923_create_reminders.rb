class CreateReminders < ActiveRecord::Migration[7.1]
  def change
    create_table :reminders do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.datetime :due_date, null: false
      t.boolean :completed, default: false

      t.timestamps
    end
  end
end
