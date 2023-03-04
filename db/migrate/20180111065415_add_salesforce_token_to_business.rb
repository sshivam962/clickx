class AddSalesforceTokenToBusiness < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :salesforce_auth, :jsonb, default: {}
  end
end
