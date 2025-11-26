class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :meal

  validates :rating, presence: true, inclusion: { in: 1..5 }   # ★必須
  validates :content, length: { maximum: 300 }
end
