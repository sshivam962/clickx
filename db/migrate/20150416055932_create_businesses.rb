class CreateBusinesses < ActiveRecord::Migration[4.2]
  def change
    create_table :businesses do |t|
      t.string :name,          null: false, default: ""
      t.string :accent_color
      t.string :logo
      t.string :support_email

      t.timestamps null: false
    end

    add_index :businesses, :name
  end
end
