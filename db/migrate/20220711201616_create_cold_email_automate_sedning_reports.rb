class CreateColdEmailAutomateSedningReports < ActiveRecord::Migration[5.2]
  def change
    create_table :cold_email_automate_sedning_reports do |t|
      t.string :name
      t.references :cold_email_batch, index: {:name => "index_cold_email_batch_report"}

      t.timestamps
    end
  end
end