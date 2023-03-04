class RemoveSalesForceFromBusinesses < ActiveRecord::Migration[5.1]
  def change
    remove_column :businesses, :salesforce_auth, :jsonb, default: {}
  end
end
