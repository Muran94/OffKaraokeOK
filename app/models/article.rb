class Article < ApplicationRecord
  validates :title, presence: true
  validates :text, presence: true, length: { maximum: 1000 }
  validates :venue, presence: true
  validates :event_date, presence: true
  validates :application_period, presence: true
  validates :capacity, presence: true, numericality: true
  validates :budget, presence: true, numericality: true
end
