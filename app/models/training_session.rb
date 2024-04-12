class TrainingSession < ApplicationRecord
  enum name: {
    personal_training: 0,
    burn: 1,
    core: 2,
    lift: 3,
    nutrition: 4,
    mindfulness: 5
  }

  belongs_to :user
  belongs_to :room_booking

  validates :name, :user_id, :room_booking_id, presence: true
  validate :user_must_be_trainer
  validate :check_room_availability, on: :create
  validate :session_within_time_limit

  before_validation :associate_or_initialize_room_booking, on: :create

  private

  def user_must_be_trainer
    errors.add(:user, "must be a trainer to create a training session") unless user&.trainer?
  end

  def check_room_availability
    existing_booking = RoomBooking.find_by(room_name: room_name, booking_time: booking_time.beginning_of_hour)
    if existing_booking.present?
      errors.add(:room_booking_id, "The room is already booked at the specified time")
    end
  end

  def associate_or_initialize_room_booking
    self.room_booking = RoomBooking.find_or_initialize_by(room_name: room_name, booking_time: booking_time.beginning_of_hour)
    if room_booking.new_record? && room_booking.invalid?
      errors.add(:base, room_booking.errors.full_messages.to_sentence)
    end
  end

  def session_within_time_limit
    if booking_time > Time.now + 1.week
      errors.add(:booking_time, "Training sessions cannot be created more than a week out")
    end
  end
end
