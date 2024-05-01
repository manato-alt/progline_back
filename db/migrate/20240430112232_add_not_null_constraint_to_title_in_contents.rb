class AddNotNullConstraintToTitleInContents < ActiveRecord::Migration[6.1]
  def change
    change_column_null :contents, :title, false
  end
end
