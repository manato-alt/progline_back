class CreateServiceRegistrations < ActiveRecord::Migration[6.1]
  def change
    create_table :service_registrations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :service, null: false, foreign_key: true

      t.timestamps
    end
  end
end
