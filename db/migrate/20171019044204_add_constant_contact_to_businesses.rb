class AddConstantContactToBusinesses < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :constant_contact_integration, :jsonb
  end
end
