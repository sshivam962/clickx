class CreateAgencyNiches < ActiveRecord::Migration[5.1]
  def change
    create_table :agency_niches do |t|
      t.references :agency, foreign_key: true
      t.references :industry, foreign_key: true
      t.text :lead_form

      t.timestamps
    end
  end
end
