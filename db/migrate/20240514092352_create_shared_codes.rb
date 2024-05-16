class CreateSharedCodes < ActiveRecord::Migration[6.1]
  def change
    create_table :shared_codes do |t|
      t.string :public_name, null: false
      t.string :code, unique: true
      t.references :user, index: {:unique=>true}, null: false, foreign_key: true

      t.timestamps
    end
  end
end
