class SharedCode < ApplicationRecord
  belongs_to :user

  validates :public_name, presence: { message: "を入力してください" }
  validates :public_name, length: { maximum: 20, message: "は20文字以内で入力してください" }
end
