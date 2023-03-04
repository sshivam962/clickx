class CreateAgencies < ActiveRecord::Migration[4.2]
  def change
    create_table :agencies do |t|
      t.string :name
      t.string :phone
      t.string :accent_color
      t.string :support_email
      t.string :logo
      t.text   :address

      t.timestamps null: false
    end
    add_index :agencies, :name
  end
end
