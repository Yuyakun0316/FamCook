class Meal < ApplicationRecord
  belongs_to :user
  has_many_attached :images

  enum meal_type: { breakfast: 0, lunch: 1, dinner: 2, snack: 3 }, _default: :dinner
  enum icon_type: {
  rice: 0, japanese: 1, western: 2, chinese: 3,
  fish: 4, healthy: 5, kids: 6, dessert: 7, drink: 8
}, _prefix: :icon

  validates :title, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 500 }, allow_blank: true
  validates :date, presence: true
  validates :meal_type, presence: true
  validates :icon_type, presence: true
end