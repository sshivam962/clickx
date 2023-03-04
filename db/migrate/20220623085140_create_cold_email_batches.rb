class CreateColdEmailBatches < ActiveRecord::Migration[5.2]
  def change
    create_table :cold_email_batches do |t|
      t.string :name
      t.integer :batch_size
      t.integer :record_count
      t.integer  :status, default: 0
      t.references :lead_source

      t.timestamps
    end
  end
end