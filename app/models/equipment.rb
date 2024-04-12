class Equipment < ApplicationRecord
  enum location: {
    mindfulness: 0,
    gym_1: 1,
    gym_2: 2,
    gym_3: 3,
    gym_4: 4,
    personal_training_1: 5,
    personal_training_2: 6,
    nutrition: 7
  }

  validates :name, :description, presence: true
  validates :is_broken, inclusion: { in: [true, false] }
  validates :location, presence: true
  validates :location, inclusion: { in: locations.keys }

  def location_name
    location.to_s.humanize.capitalize
  end
end
