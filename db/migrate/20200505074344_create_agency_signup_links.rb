class CreateAgencySignupLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :agency_signup_links do |t|
      t.float :onetime_charge
      t.string :plan_key

      t.timestamps
    end
  end
end
