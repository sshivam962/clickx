class CreateAgencyNichesAccesses < ActiveRecord::Migration[5.1]
  def change
    create_table :agency_niches_accesses do |t|
      t.references :agency, foreign_key: true
      t.boolean :full_access
      t.integer :industries_ids, array: true, default: []

      t.timestamps
    end
  end
end
