class Category < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :user
  has_many :services, dependent: :destroy

  validates :name, presence: { message: "を入力してください" }
  validates :name, length: { maximum: 20, message: "は20文字以内で入力してください" }
end
