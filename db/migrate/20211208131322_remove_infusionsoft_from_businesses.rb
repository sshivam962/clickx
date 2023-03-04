class RemoveInfusionsoftFromBusinesses < ActiveRecord::Migration[5.1]
  def change
    remove_column :businesses, :infusionsoft_integration, :jsonb
  end
end
