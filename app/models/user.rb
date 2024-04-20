class User < ApplicationRecord
  has_many :term_registrations
  has_many :categories, through: :term_registrations
  has_many :service_registrations
  has_many :services, through: :service_registrations
end
