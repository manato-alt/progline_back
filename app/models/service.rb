class Service < ApplicationRecord
  has_one_attached :image
  belongs_to :category
  has_many :contents, dependent: :destroy
end
