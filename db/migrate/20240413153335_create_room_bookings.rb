class CreateRoomBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :room_bookings do |t|
      t.integer :room_name, null: false, default: 0
      t.text :location
      t.datetime :booking_time, null: false, default: -> { "DATE_TRUNC('hour', CURRENT_TIMESTAMP) + INTERVAL '1 hour'" }

      t.timestamps
    end
  end
end
