class Content < ApplicationRecord
  belongs_to :service
  has_one_attached :image
end
