class SharedCode < ApplicationRecord
  belongs_to :user

  validates :public_name, presence: true
end
