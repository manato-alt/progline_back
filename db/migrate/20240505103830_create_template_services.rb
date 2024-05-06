class CreateTemplateServices < ActiveRecord::Migration[6.1]
  def change
    create_table :template_services do |t|
      t.string :name
      t.string :image_url

      t.timestamps
    end
  end
end
