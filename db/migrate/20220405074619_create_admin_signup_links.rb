class CreateAdminSignupLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_calendly_scripts do |t|
      t.references :user
      t.text :calendly_script

      t.timestamps
    end
  end
end
