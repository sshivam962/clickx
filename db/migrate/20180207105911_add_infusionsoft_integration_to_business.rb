class AddInfusionsoftIntegrationToBusiness < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :infusionsoft_integration, :jsonb
  end
end
