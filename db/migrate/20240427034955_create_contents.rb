class CreateContents < ActiveRecord::Migration[6.1]
  def change
    create_table :contents do |t|
      t.string :title, null: false
      t.string :original_url
      t.string :favicon_url
      t.string :url
      t.string :image
      t.references :service, null: false, foreign_key: true

      t.timestamps
    end
  end
end
