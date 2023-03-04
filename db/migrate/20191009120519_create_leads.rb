class CreateLeads < ActiveRecord::Migration[5.1]
  def change
    create_table :leads do |t|
      t.string :first_name,   null: false
      t.string :last_name
      t.string :email,        null: false
      t.string :company,      null: false
      t.string :phone
      t.string :domain

      t.references :agency,   index: true

      t.timestamps
    end
  end
end
