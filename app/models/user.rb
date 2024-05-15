class User < ApplicationRecord
  has_many :categories, dependent: :destroy
  has_one :shared_code
end
