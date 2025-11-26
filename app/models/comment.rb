class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :meal

  # ⭐ 評価（必須）・1〜5まで
  validates :rating,
            presence: true,
            inclusion: {
              in: 1..5,
              message: 'は1〜5の範囲で入力してください'
            }

  # 💬 コメント（任意・最大300文字）
  validates :content,
            length: { maximum: 300 },
            allow_blank: true

  # 🛑 ユーザー & 献立との関連がないと保存させない
  validates :user, presence: true
  validates :meal, presence: true
end
