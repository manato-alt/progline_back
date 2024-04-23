class AddUniqueConstraintToServiceRegistrations < ActiveRecord::Migration[6.1]
  def change
    add_index :service_registrations, [:user_id, :category_id, :service_id], unique: true, name: 'index_unique_service_registrations_on_user_category_service'
  end
end
