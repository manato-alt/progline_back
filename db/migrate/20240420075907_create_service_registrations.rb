class CreateServiceRegistrations < ActiveRecord::Migration[6.1]
  def change
    create_table :service_registrations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :service, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :service_registrations, [:user_id, :category_id, :service_id], unique: true, name: 'index_unique_service_registrations_on_user_category_service'
  end
end
