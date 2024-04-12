class CreateMemberSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :member_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :training_session, null: false, foreign_key: true

      t.timestamps
    end
  end
end
