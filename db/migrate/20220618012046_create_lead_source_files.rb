class CreateLeadSourceFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :lead_source_files do |t|
      t.string :filename
      t.references :lead_source

      t.timestamps
    end
  end
end
