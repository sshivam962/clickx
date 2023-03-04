class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :first_name
      t.string :last_name
      t.text :address_line_1
      t.text :address_line_2
      t.string :city
      t.string :country
      t.string :state
      t.string :zip

      t.references :addressable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
