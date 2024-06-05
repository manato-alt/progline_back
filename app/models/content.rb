class Content < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :service

  validates :title, presence: { message: "を入力してください" }
  validates :title, length: { maximum: 100, message: "は100文字以内で入力してください" }
  validates :url, length: { maximum: 2048, message: "は2048文字以内で入力してください" }
end
