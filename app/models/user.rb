class User < ApplicationRecord
  has_many :meals, dependent: :destroy
  has_many :memos, dependent: :destroy
  attr_accessor :family_code # フォーム入力用（DBに直接保存しない）

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :family, optional: true

  def family_owner?
    family&.owner_id == id
  end

  def owned_family
    Family.find_by(owner_id: id)
  end

  def self.guest
  find_by!(email: 'guest@example.com')
  end

  validates :name, presence: true, length: { maximum: 20 }
end
