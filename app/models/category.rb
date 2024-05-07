class Category < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :services, dependent: :destroy
end
