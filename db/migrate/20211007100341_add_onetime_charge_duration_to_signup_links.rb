class AddOnetimeChargeDurationToSignupLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :signup_links, :onetime_charge_duration, :integer
  end
end
