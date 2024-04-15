class User < ApplicationRecord
  has_many :term_registrations
  has_many :categories, through: :term_registrations
end
