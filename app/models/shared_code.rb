class SharedCode < ApplicationRecord
  belongs_to :user

  validates :public_name, presence: true
  validates :public_name, length: { maximum: 20 }
end
