class HealthMetric < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :user, inclusion: { in: ->(health_metric) { User.member } }

  before_validation :check_metric_ranges
  before_validation :calculate_bmi, if: -> { height.present? && weight.present? }

  scope :recent, -> { order(created_at: :desc) }

  private

  def calculate_bmi
    self.bmi = weight.to_f / (height.to_f * height.to_f)
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
