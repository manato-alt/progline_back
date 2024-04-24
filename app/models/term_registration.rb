class TermRegistration < ApplicationRecord
  validate :check_uniqueness_of_user_id_within_category
  belongs_to :user
  belongs_to :category

  def check_uniqueness_of_user_id_within_category
    existing_registration = TermRegistration.find_by(category_id: category_id, user_id: user_id)
    if existing_registration
      errors.add(:base, "選択されたカテゴリは既に登録されています")
    end
  end
end
