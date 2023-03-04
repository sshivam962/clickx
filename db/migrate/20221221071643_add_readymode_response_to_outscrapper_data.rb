class AddReadymodeResponseToOutscrapperData < ActiveRecord::Migration[5.2]
  def change
    add_column :outscrapper_data, :readymode_response, :jsonb
  end
end
