class AddPipeDriveIntegrationToBusiness < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :pipe_drive_integration, :jsonb
  end
end
