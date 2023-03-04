class AddYextCredsToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :yext_api_key, :string
    add_column :agencies, :yext_customer_id, :string
  end
end
