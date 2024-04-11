class User < ApplicationRecord
  enum role: { member: 0, trainer: 1, admin: 2 }

  validates :first_name, :last_name, :email, :role, :date_of_birth, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :role, inclusion: { in: roles.keys }

  before_save :downcase_email, :capitalize_and_clean_name, :age

  private

  def age
    if date_of_birth.present? && date_of_birth < 18.years.ago && date_of_birth > 65.years.ago
      errors.add(:date_of_birth, "must be between 18 and 65 years old")
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
