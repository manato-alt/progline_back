class Category < ApplicationRecord
  has_many :term_registrations
  has_many :users, through: :term_registrations
  has_one_attached :image
end
