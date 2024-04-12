class RoomBooking < ApplicationRecord
  enum room_name: {
    mindfulness: 0,
    gym_1: 1,
    gym_2: 2,
    gym_3: 3,
    gym_4: 4,
    personal_training_1: 5,
    personal_training_2: 6,
    nutrition: 7
  }

  has_many :training_sessions, dependent: :destroy

  validates :room_name, :booking_time, presence: true
  validate: :ensure_unique_booking_time_for_room

  before_validation :round_off_booking_time, :fill_location

  private

  def ensure_unique_booking_time_for_room
    if RoomBooking.where(room_name: room_name, booking_time: booking_time).exists?
      errors.add(:booking_time, "is already booked for this room")
    end
  end

  def round_off_booking_time
    self.booking_time = booking_time.beginning_of_hour + 1.hour
  end

  def fill_location
    self.location = "#{room_name.to_s.humanize.capitalize} Room"
  end
end
