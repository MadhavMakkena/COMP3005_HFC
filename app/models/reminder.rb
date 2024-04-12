class Reminder < ApplicationRecord
  validates :title, :content, :due_date, presence: true
  validates :completed, inclusion: { in: [true, false] }

  before_validation :capitalize_title

  private

  def capitalize_title
    self.title = title.strip.capitalize if title.present?
  end
end
