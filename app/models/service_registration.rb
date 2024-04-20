class ServiceRegistration < ApplicationRecord
  belongs_to :user
  belongs_to :category
  belongs_to :service
end
