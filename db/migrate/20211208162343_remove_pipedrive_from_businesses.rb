class RemovePipedriveFromBusinesses < ActiveRecord::Migration[5.1]
  def change
    remove_column :businesses, :pipe_drive_integration, :jsonb
  end
end
