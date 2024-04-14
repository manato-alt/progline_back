class Category < ApplicationRecord
  has_many :term_registrations
  has_one_attached :image
end
