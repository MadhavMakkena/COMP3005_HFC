class CreateAnnouncements < ActiveRecord::Migration[7.1]
  def change
    create_table :announcements do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.integer :for_user_type
      t.references :user

      t.timestamps
    end
  end
end
