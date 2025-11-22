class Meal < ApplicationRecord
  belongs_to :user
  has_many_attached :images

  enum meal_type: { breakfast: 0, lunch: 1, dinner: 2, snack: 3 }, _default: :dinner

  validates :title, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 500 }, allow_blank: true
  validates :date, presence: true
  validates :meal_type, presence: true
end