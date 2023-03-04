class RemoveCitrixFromBusinesses < ActiveRecord::Migration[5.1]
  def change
    remove_column :businesses, :citirix_integration, :jsonb
  end
end
