class Meal < ApplicationRecord
  belongs_to :user
  belongs_to :family
  has_many_attached :images
  has_many :comments, dependent: :destroy

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

  def average_rating
    return 0 unless comments.any?

    comments.average(:rating).round(1)
  end

  private

  def validate_image_count
    return unless images.attached? && images.count > 3

    errors.add(:images, 'は3枚まで投稿できます')
  end

  def self.human_attribute_name(attr, options = {})
    case attr.to_sym
    when :title
      '献立名'
    when :icon_type
      '食事アイコン'
    else
      super
    end
  end
end
