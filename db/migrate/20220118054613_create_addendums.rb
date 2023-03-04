class CreateAddendums < ActiveRecord::Migration[5.1]
  def change
    create_table :addendums do |t|
      t.references :agency, foreign_key: true
      t.boolean :signed
      t.string :file
      t.string :signature

      t.timestamps
    end
  end
end
