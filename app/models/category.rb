class Category < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :services, dependent: :destroy

  validates :name, presence: { message: "を入力してください" }
  validates :name, length: { maximum: 20, message: "は20文字以内で入力してください" }
end
