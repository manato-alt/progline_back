class CreateTermRegistrations < ActiveRecord::Migration[6.1]
  def change
    create_table :term_registrations do |t|
      t.references :user, foreign_key: true, null: false
      t.references :category, foreign_key: true, null: false

      t.timestamps
    end

    add_index :term_registrations, [:user_id, :category_id], unique: true
  end
end
