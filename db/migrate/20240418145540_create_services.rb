class CreateServices < ActiveRecord::Migration[6.1]
  def change
    create_table :services do |t|
      t.string :name
      t.string :original_url
      t.string :image
      t.references :category, null: false, foreign_key: true
      t.timestamps
    end
  end
end
