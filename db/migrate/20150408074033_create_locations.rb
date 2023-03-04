class CreateLocations < ActiveRecord::Migration[4.2]
  def change
    create_table :locations do |t|
      t.string :name,    null: false
      t.text   :address
      t.string :city
      t.string :state
      t.string :country
      t.string :zip

      t.string :phone
      t.string :mobile_phone
      t.string :toll_free
      t.string :website
      t.string :enquiry_email
      t.string :fax
      t.string :logo

      t.string :categories,                array: true, default: []
      t.string :operational_hours,         array: true, default: []
      t.string :payment_methods,           array: true, default: []
      t.string :products_services,         array: true, default: []
      t.string :brands,                    array: true, default: []
      t.string :images,                    array: true, default: []
      t.string :languages,                 array: true, default: []
      t.string :professional_associations, array: true, default: []

      t.text   :slogan,                    limit: 80
      t.text   :keywords,                  limit: 255
      t.text   :short_description,         limit: 140
      t.text   :medium_description,        limit: 200
      t.text   :full_description,          limit: 500
      t.text   :long_description,          limit: 1500

      t.integer :number_of_users,          limit: 8
      t.integer :year_established
      t.integer :unique_id

      t.references :user,                  index: true

      t.timestamps null: false
    end

    add_index :locations, :name,                unique: true
  end
end
