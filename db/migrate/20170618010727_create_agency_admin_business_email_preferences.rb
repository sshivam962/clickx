class CreateAgencyAdminBusinessEmailPreferences < ActiveRecord::Migration[4.2]
  def change
    create_table :agency_admin_business_email_preferences do |t|
      t.references :user, index: true, foreign_key: true
      t.references :business, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
