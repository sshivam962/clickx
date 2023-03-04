class RemoveMailchimpIntegrationFromBusinesses < ActiveRecord::Migration[5.1]
  def change
    remove_column :businesses, :mailchimp_integration, :jsonb
  end
end
