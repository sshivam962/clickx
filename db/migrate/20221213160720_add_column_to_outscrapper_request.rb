class AddColumnToOutscrapperRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :outscrapper_requests, :lead_source_id, :integer, default: nil
  end
end
