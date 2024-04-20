class Category < ApplicationRecord
  has_many :term_registrations
  has_many :users, through: :term_registrations
  has_one_attached :image
  has_many :service_registrations
  has_many :services, through: :service_registrations
end
