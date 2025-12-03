class Meal < ApplicationRecord
  belongs_to :user
  belongs_to :family
  has_many_attached :images
  has_many :comments, dependent: :destroy

  enum meal_type: { breakfast: 0, lunch: 1, dinner: 2, snack: 3 }, _default: :dinner
  enum icon_type: {
    don: 0,           # 🍚 丼・ごはん系
    curry: 1,         # 🍛 カレー
    meat: 2,          # 🍖 肉料理
    fried: 3,         # 🍤 揚げ物
    fish: 4,          # 🐟 魚料理
    japanese: 5,      # 🍣 和食系
    bento: 6,         # 🍱 弁当
    pasta: 7,         # 🍝 パスタ系
    noodles: 8,       # 🍜 麺類
    chinese: 9,       # 🥟 中華系
    western_fast: 10, # 🍕 洋食/ファスト
    bread: 11,        # 🍞 パン系
    nabe: 12,         # 🍲 鍋料理
    kids: 13,         # 🍔 子供向け
    salad: 14         # 🥗 サラダ系
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
