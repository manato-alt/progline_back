class Content < ApplicationRecord
  belongs_to :service
  has_one_attached :image

  validates :title, presence: true
  validates :title, length: { maximum: 100 }
  validates :url, length: { maximum: 2048 }
end
