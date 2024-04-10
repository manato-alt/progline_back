class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :image_url
      t.boolean :is_original, default: false
      t.timestamps
    end
  end
end
