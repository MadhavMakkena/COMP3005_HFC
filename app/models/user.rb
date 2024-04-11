class User < ApplicationRecord
  enum role: { member: 0, trainer: 1, admin: 2 }

  validates :first_name, :last_name, :email, :role, :date_of_birth, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :role, inclusion: { in: roles.keys }

  before_validation :downcase_email, :capitalize_and_clean_name, :date_of_birth_check
  before_save :downcase_email, :capitalize_and_clean_name, :date_of_birth_check

  has_many :health_metrics, dependent: :destroy

  private

  def date_of_birth_check
    begin
      parsed_date = Date.parse(date_of_birth.to_s)
    rescue ArgumentError
      errors.add(:date_of_birth, "is invalid. Please enter a date in YYYY-MM-DD format.")
      return
    end

    if parsed_date < 100.years.ago.to_date || parsed_date > 18.years.ago.to_date
      errors.add(:date_of_birth, "must be between 18 and 100 years old")
    end
  end


  def downcase_email
    self.email = email.downcase
  end

  def capitalize_and_clean_name
    self.first_name = first_name.strip.gsub(/[^a-zA-Z]/, "").capitalize
    self.last_name = last_name.strip.gsub(/[^a-zA-Z]/, "").capitalize
  end
end
