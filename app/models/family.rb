class Family < ApplicationRecord
  has_many :users, dependent: :nullify

  # 👑 家族管理者の設定（新規作成時は owner なし → 保存可能にする）
  belongs_to :owner, class_name: 'User', optional: true

  # 招待コードは必ず存在する
  validates :code, presence: true, uniqueness: true
end
