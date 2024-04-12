class Announcement < ApplicationRecord
  enum for_user_type: { member: 0, trainer: 1, admin: 2 }

  validates :title, :content, :for_user_type, presence: true

  before_validation :capitalize_title

  private

  def capitalize_title
    self.title = title.strip.capitalize if title.present?
  end
end
