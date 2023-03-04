class CreateTrackerPhoneNumbers < ActiveRecord::Migration[4.2]
  def change
    create_table :tracker_phone_numbers do |t|
      t.string :number
      t.references :tracker_contact, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
