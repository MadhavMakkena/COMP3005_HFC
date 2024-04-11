class CreateHealthMetrics < ActiveRecord::Migration[7.1]
  def change
    create_table :health_metrics do |t|
      t.references :user, null: false, foreign_key: true

      t.decimal :height, precision: 5, scale: 2
      t.decimal :weight, precision: 5, scale: 2
      t.decimal :bmi, precision: 5, scale: 2
      t.integer :hydration
      t.decimal :muscle_mass, precision: 5, scale: 2
      t.integer :caloric_intake
      t.integer :caloric_burn
      t.integer :steps
      t.integer :sleep_quality
      t.integer :resting_heart_rate

      t.timestamps
    end
  end
end
