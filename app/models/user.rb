class User < ApplicationRecord
  enum role: { member: 0, trainer: 1, admin: 2 }

  validates :first_name, :last_name, :email, :role, :date_of_birth, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :role, inclusion: { in: roles.keys }

  before_validation :downcase_email, :capitalize_and_clean_name, :date_of_birth_check

  has_many :health_metrics, dependent: :destroy
  has_many :training_sessions, dependent: :destroy
  has_many :member_sessions, dependent: :destroy
  has_many :payments, dependent: :destroy

  def name
    "#{first_name} #{last_name}"
  end

  private

  def date_of_birth_check
    errors.add(:date_of_birth, "is invalid. Please enter a date in YYYY-MM-DD format.") unless date_of_birth.is_a?(Date)

    if date_of_birth && (date_of_birth < 100.years.ago.to_date || date_of_birth > 18.years.ago.to_date)
      errors.add(:date_of_birth, "must be between 18 and 100 years old")
    end
  end

  def downcase_email
    self.email = email.downcase if email.present?
  end

  def capitalize_and_clean_name
    self.first_name = first_name.strip.gsub(/[^a-zA-Z]/, "").capitalize if first_name.present?
    self.last_name = last_name.strip.gsub(/[^a-zA-Z]/, "").capitalize if last_name.present?
  end
end
