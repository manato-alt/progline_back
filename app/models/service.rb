class Service < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :category
  has_many :contents, dependent: :destroy


  validates :name, presence: { message: "を入力してください" }
  validates :name, length: { maximum: 20, message: "は20文字以内で入力してください" }
end
