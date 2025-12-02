class Family < ApplicationRecord
  has_many :users, dependent: :nullify

  # 👑 家族管理者の設定
  belongs_to :owner, class_name: "User"

  # 招待コードは必ず存在する
  validates :code, presence: true, uniqueness: true
end
