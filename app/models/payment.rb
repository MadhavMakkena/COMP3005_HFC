class Payment < ApplicationRecord
  validates :user_id, presence: true
  validates :payment_date, presence: true

  belongs_to :user
end
