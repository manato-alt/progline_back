class Service < ApplicationRecord
  has_many :service_registrations
  has_many :users, through: :service_registrations
  has_many :categories, through: :service_registrations
  has_one_attached :image
end
