class Log < ApplicationRecord
  belongs_to :wod

  validates :date, presence: true
  validates :rate, numericality: { greater_than_or_equal_to: 0.5, less_than_or_equal_to: 5.0 }
end
