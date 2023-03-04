class ChangeTrialExpiryDateTypeInBusiness < ActiveRecord::Migration[4.2]
  def change
  change_column :businesses, :trial_expiry_date, 'date USING CAST(trial_expiry_date AS date)'
  end
end
