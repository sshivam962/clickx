class FixTyposInPageForm < ActiveRecord::Migration[4.2]
  def change
    rename_column :page_forms, :forms, :form
    rename_column :page_forms, :validate_fileds, :validate_fields
  end
end
