class AddMailchimpIntegrationToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :mailchimp_integration, :jsonb
  end
end
