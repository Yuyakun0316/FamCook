class Family < ApplicationRecord
  has_many :users, dependent: :destroy

  # 招待コードは必ず存在する
  validates :code, presence: true, uniqueness: true
end
