class User < ApplicationRecord
  has_many :meals, dependent: :destroy
  has_many :memos, dependent: :destroy
  attr_accessor :family_code  # フォーム入力用（DBに直接保存しない）
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  belongs_to :family, optional: true

  validates :name, presence: true, length: { maximum: 20 }
end
