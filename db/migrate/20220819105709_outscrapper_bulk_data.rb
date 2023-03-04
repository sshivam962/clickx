class OutscrapperBulkData < ActiveRecord::Migration[5.2]
  def change
    create_table :outscrapper_bulk_data do |t|
      t.references :lead_source
      t.string :filename
      t.jsonb :cleaned_data
      t.boolean :status_success, default: false

      t.timestamps
    end
  end
end
