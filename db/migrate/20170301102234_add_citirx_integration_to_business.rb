class AddCitirxIntegrationToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :citirix_integration, :jsonb
  end
end
