class Memo < ApplicationRecord
  belongs_to :user
  belongs_to :family
  validates :content, presence: true

  scope :pinned_first, -> { order(pinned: :desc, created_at: :desc) }
end
