class AddFieldsToPageForms < ActiveRecord::Migration[4.2]
  def change
    add_column :page_forms,:multi_page,:boolean,default: false
    add_column :page_forms,:form_hash,:string
    add_column :page_forms,:form_id,:string
    add_column :page_forms,:required_fields,:jsonb,default: []
    add_column :page_forms,:success_url,:string
    add_column :page_forms,:verify_field,:boolean,default: false
    add_column :page_forms,:validate_fileds,:boolean,default: false
  end
end
