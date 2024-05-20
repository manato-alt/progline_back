class Category < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :services, dependent: :destroy

  validates :name, presence: true
  validates :name, length: { in: 1..20 }
end
