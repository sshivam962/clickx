class CreateTrackerContacts < ActiveRecord::Migration[4.2]
  def change
    create_table :tracker_contacts do |t|
      t.string :fname
      t.string :lname
      t.string :address
      t.string :organization
      t.string :phone
      t.datetime :dob
      t.string :email
      t.string :gender
      t.string :job_title
      t.string :nationality
      t.references :tracker_visitor

      t.references :business,  index: true
      t.timestamps null: false
    end
  end
end
