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
  accepts_nested_attributes_for :room_booking

  validates :name, :user_id, presence: true
  validate :user_must_be_trainer

  private

  def user_must_be_trainer
    errors.add(:user, "must be a trainer to create a training session") unless user&.trainer?
  end
end

# Sun, 14 Apr 2024 00:00:00
