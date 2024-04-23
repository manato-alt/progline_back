class AddUniqueIndexToTermRegistrations < ActiveRecord::Migration[6.1]
  def change
    add_index :term_registrations, [:user_id, :category_id], unique: true
  end
end
