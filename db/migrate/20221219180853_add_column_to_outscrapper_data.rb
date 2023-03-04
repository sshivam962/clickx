class AddColumnToOutscrapperData < ActiveRecord::Migration[5.2]
  def change
    add_column :outscrapper_data, :deleted_at, :boolean, default: nil
  end
end
