class HealthMetric < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true

  before_validation :check_user_role, :calculate_bmi, :check_metric_ranges
  before_save :check_user_role, :calculate_bmi, :check_metric_ranges

  scope :recent, -> { order(created_at: :desc) }

  private

  def check_user_role
    member_ids = User.where(role: 'member').pluck(:id)
    unless member_ids.include?(user_id)
      errors.add(:user_id, "must be a member user id")
    end
  end

  def calculate_bmi
    if height.present? && weight.present? && height > 0
      self.bmi = weight.to_f / (height * height)
    end
  end

  def check_metric_ranges
    { height: 40.0..400.0, weight: 40.0..400.0, muscle_mass: 20.0..100.0,
      hydration: 50..100, caloric_intake: 0..5000, caloric_burn: 0..5000,
      steps: 0..20000, sleep_quality: 1..10, resting_heart_rate: 40..140 }.each do |key, range|
      value = send(key)
      if value.present? && !range.include?(value)
        errors.add(key, "must be between #{range.begin} and #{range.end}")
      end
    end
  end
end
