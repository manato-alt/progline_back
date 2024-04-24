class ServiceRegistration < ApplicationRecord
  validate :check_uniqueness_of_service_id_within_category_and_user
  belongs_to :user
  belongs_to :category
  belongs_to :service

  def check_uniqueness_of_service_id_within_category_and_user
    existing_registration = ServiceRegistration.find_by(category_id: category_id, user_id: user_id, service_id: service_id)
    if existing_registration
      errors.add(:base, "選択されたサービスは既に登録されています")
    end
  end
end
