class AddColumnToOutscrapperRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :outscrapper_requests, :deleted_at, :boolean, default: nil
  end
end
