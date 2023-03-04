class CreateTwillioContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :twillio_contacts do |t|
      t.string :name
      t.string :phone, null: false

      t.timestamps
    end
  end
end
