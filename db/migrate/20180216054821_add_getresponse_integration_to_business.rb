class AddGetresponseIntegrationToBusiness < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :getresponse_integration, :jsonb
  end
end
